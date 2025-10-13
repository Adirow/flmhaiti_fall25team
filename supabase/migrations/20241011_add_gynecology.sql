-- Add Gynecology Department and Tools
-- This migration adds the gynecology department and its tools

-- 插入妇科科室
INSERT INTO departments (code, name, description) VALUES 
('gynecology', 'Gynecology', 'Women''s health and reproductive care department')
ON CONFLICT (code) DO NOTHING;

-- 插入盆腔图工具
INSERT INTO encounter_tools (code, name, description, icon_name, is_universal) VALUES 
('pelvic_diagram', 'Pelvic Diagram', 'Gynecological pelvic examination and annotation tool', 'medical_information', false)
ON CONFLICT (code) DO NOTHING;

-- 关联工具到妇科科室
INSERT INTO department_tools (department_id, tool_id, display_order, is_required, tool_config)
SELECT 
    d.id,
    t.id,
    CASE t.code 
        WHEN 'pelvic_diagram' THEN 1
        WHEN 'progress_notes' THEN 2
    END,
    CASE t.code 
        WHEN 'progress_notes' THEN true
        ELSE false
    END,
    CASE t.code 
        WHEN 'pelvic_diagram' THEN '{"show_anatomy_labels": true, "enable_annotations": true, "default_view": "frontal"}'::jsonb
        WHEN 'progress_notes' THEN '{"template": "gynecology", "required_fields": ["examination", "assessment"]}'::jsonb
        ELSE '{}'::jsonb
    END
FROM departments d
CROSS JOIN encounter_tools t
WHERE d.code = 'gynecology' 
AND t.code IN ('pelvic_diagram', 'progress_notes')
ON CONFLICT (department_id, tool_id) DO NOTHING;
