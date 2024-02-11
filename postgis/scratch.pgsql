SELECT *
-- Shows all available tables
-- FROM information_schema.tables;
-- FROM public.spatial_ref_sys;
FROM spatial_ref_sys
WITH srtext LIKE 3587;
-- WHERE table_name = 'spatial_ref_sys';