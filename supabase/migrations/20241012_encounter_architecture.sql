-- Encounter Architecture Migration
-- Phase 1: Create extensible encounter system tables

-- 科室定义表
CREATE TABLE IF NOT EXISTS departments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,  -- 'dental', 'gynecology', 'dermatology'
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 工具定义表
CREATE TABLE IF NOT EXISTS encounter_tools (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) NOT NULL,  -- 'tooth_map', 'progress_notes', 'pelvic_diagram'
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon_name VARCHAR(50),
    component_path VARCHAR(200),  -- Flutter 组件路径
    is_universal BOOLEAN DEFAULT false,  -- 是否为通用工具
    config JSONB DEFAULT '{}',  -- 工具特定配置
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(code)
);

-- 科室-工具关联表
CREATE TABLE IF NOT EXISTS department_tools (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    department_id UUID REFERENCES departments(id) ON DELETE CASCADE,
    tool_id UUID REFERENCES encounter_tools(id) ON DELETE CASCADE,
    display_order INTEGER DEFAULT 0,
    is_required BOOLEAN DEFAULT false,
    tool_config JSONB DEFAULT '{}',  -- 科室特定的工具配置覆盖
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(department_id, tool_id)
);

-- 扩展 encounters 表 (添加新字段，保持向后兼容)
ALTER TABLE encounters 
ADD COLUMN IF NOT EXISTS department_id UUID REFERENCES departments(id),
ADD COLUMN IF NOT EXISTS status VARCHAR(50) DEFAULT 'active',
ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}';

-- 工具数据存储表
CREATE TABLE IF NOT EXISTS encounter_tool_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    encounter_id UUID REFERENCES encounters(id) ON DELETE CASCADE,
    tool_id UUID REFERENCES encounter_tools(id) ON DELETE CASCADE,
    data JSONB NOT NULL,  -- 工具产生的数据
    version INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(encounter_id, tool_id, version)
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_departments_code ON departments(code);
CREATE INDEX IF NOT EXISTS idx_encounter_tools_code ON encounter_tools(code);
CREATE INDEX IF NOT EXISTS idx_department_tools_dept ON department_tools(department_id);
CREATE INDEX IF NOT EXISTS idx_department_tools_tool ON department_tools(tool_id);
CREATE INDEX IF NOT EXISTS idx_encounters_department ON encounters(department_id);
CREATE INDEX IF NOT EXISTS idx_encounter_tool_data_encounter ON encounter_tool_data(encounter_id);
CREATE INDEX IF NOT EXISTS idx_encounter_tool_data_tool ON encounter_tool_data(tool_id);

-- 插入默认数据
INSERT INTO departments (code, name, description) VALUES 
('dental', 'Dental', 'Dental department for oral health care')
ON CONFLICT (code) DO NOTHING;

INSERT INTO encounter_tools (code, name, description, icon_name, is_universal) VALUES 
('progress_notes', 'Progress Notes', 'General progress notes for all departments', 'edit_note', true),
('tooth_map', 'Tooth Map', 'Dental tooth mapping and charting tool', 'grid_view', false)
ON CONFLICT (code) DO NOTHING;

-- 关联默认工具到 dental 科室
INSERT INTO department_tools (department_id, tool_id, display_order)
SELECT 
    d.id,
    t.id,
    CASE t.code 
        WHEN 'tooth_map' THEN 1
        WHEN 'progress_notes' THEN 2
    END
FROM departments d
CROSS JOIN encounter_tools t
WHERE d.code = 'dental' 
AND t.code IN ('tooth_map', 'progress_notes')
ON CONFLICT (department_id, tool_id) DO NOTHING;

-- 为现有 encounters 设置默认科室
UPDATE encounters 
SET department_id = (SELECT id FROM departments WHERE code = 'dental' LIMIT 1)
WHERE department_id IS NULL;

-- 添加 RLS 策略 (Row Level Security)
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE encounter_tools ENABLE ROW LEVEL SECURITY;
ALTER TABLE department_tools ENABLE ROW LEVEL SECURITY;
ALTER TABLE encounter_tool_data ENABLE ROW LEVEL SECURITY;

-- 创建 RLS 策略 (基于 clinic_id)
CREATE POLICY "Users can view departments" ON departments FOR SELECT USING (true);
CREATE POLICY "Users can view encounter_tools" ON encounter_tools FOR SELECT USING (true);
CREATE POLICY "Users can view department_tools" ON department_tools FOR SELECT USING (true);

CREATE POLICY "Users can manage encounter_tool_data" ON encounter_tool_data 
FOR ALL USING (
    EXISTS (
        SELECT 1 FROM encounters e 
        WHERE e.id = encounter_tool_data.encounter_id 
        AND e.clinic_id = (auth.jwt() ->> 'clinic_id')::uuid
    )
);
