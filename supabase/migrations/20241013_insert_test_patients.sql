-- Insert departments if they don't exist
INSERT INTO departments (code, name, description) VALUES 
('dental', 'Dental', 'Dental care and oral health services'),
('gynecology', 'Gynecology', 'Women''s health and reproductive care')
ON CONFLICT (code) DO NOTHING;

-- Insert encounter tools if they don't exist
INSERT INTO encounter_tools (code, name, description, icon_name, is_universal) VALUES 
('progress_notes', 'Progress Notes', 'Clinical progress notes and documentation', 'edit_note', true),
('tooth_map', 'Tooth Map', 'Dental tooth mapping and charting tool', 'grid_view', false),
('pelvic_diagram', 'Pelvic Diagram', 'Gynecological pelvic examination tool', 'medical_information', false)
ON CONFLICT (code) DO NOTHING;

-- Link tools to departments
INSERT INTO department_tools (department_id, tool_id, display_order, is_required, tool_config)
SELECT 
    d.id,
    t.id,
    CASE t.code 
        WHEN 'tooth_map' THEN 1
        WHEN 'progress_notes' THEN 2
        WHEN 'pelvic_diagram' THEN 1
    END,
    CASE t.code 
        WHEN 'progress_notes' THEN true
        ELSE false
    END,
    CASE t.code 
        WHEN 'tooth_map' THEN '{"show_tooth_numbers": true, "enable_charting": true}'::jsonb
        WHEN 'pelvic_diagram' THEN '{"show_anatomy_labels": true, "enable_annotations": true, "default_view": "frontal"}'::jsonb
        WHEN 'progress_notes' THEN '{"template": "standard", "required_fields": ["examination", "assessment"]}'::jsonb
        ELSE '{}'::jsonb
    END
FROM departments d
CROSS JOIN encounter_tools t
WHERE (d.code = 'dental' AND t.code IN ('tooth_map', 'progress_notes'))
   OR (d.code = 'gynecology' AND t.code IN ('pelvic_diagram', 'progress_notes'))
ON CONFLICT (department_id, tool_id) DO NOTHING;
