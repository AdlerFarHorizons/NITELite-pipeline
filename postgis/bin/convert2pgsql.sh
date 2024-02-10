# docker exec postgis-night-horizons-1
raster2pgsql -s 3857 /home/*.tif public.nitelite2 \
| psql -U gis -d gis
# Register the raster as an out-of-db (filesystem) raster.
#  -s 3857 -C -R -t 100x100 
# -S 3857 \ # Pseudo-Mercator
# -I \ # Create a GIST spatial index on the raster column.
# -F \ # Include a filename column
# public.nitelite # Table name

# raster2pgsql --help below
# RELEASE: 3.4.1 GDAL_VERSION=32 (ca035b9)
# USAGE: raster2pgsql [<options>] <raster>[ <raster>[ ...]] [[<schema>.]<table>]
#   Multiple rasters can also be specified using wildcards (*,?).
# 
# OPTIONS:
#   -s <srid> Set the SRID field. Defaults to 0. If SRID not
#      provided or is 0, raster's metadata will be checked to
#      determine an appropriate SRID.
#   -b <band> Index (1-based) of band to extract from raster. For more
#       than one band index, separate with comma (,). Ranges can be
#       defined by separating with dash (-). If unspecified, all bands
#       of raster will be extracted.
#   -t <tile size> Cut raster into tiles to be inserted one per
#       table row. <tile size> is expressed as WIDTHxHEIGHT.
#       <tile size> can also be "auto" to allow the loader to compute
#       an appropriate tile size using the first raster and applied to
#       all rasters.
#   -P Pad right-most and bottom-most tiles to guarantee that all tiles
#      have the same width and height.
#   -R  Register the raster as an out-of-db (filesystem) raster. Provided
#       raster should have absolute path to the file
#  (-d|a|c|p) These are mutually exclusive options:
#      -d  Drops the table, then recreates it and populates
#          it with current raster data.
#      -a  Appends raster into current table, must be
#          exactly the same table schema.
#      -c  Creates a new table and populates it, this is the
#          default if you do not specify any options.
#      -p  Prepare mode, only creates the table.
#   -f <column> Specify the name of the raster column
#   -F  Add a column with the filename of the raster.
#   -n <column> Specify the name of the filename column. Implies -F.
#   -l <overview factor> Create overview of the raster. For more than
#       one factor, separate with comma(,). Overview table name follows
#       the pattern o_<overview factor>_<table>. Created overview is
#       stored in the database and is not affected by -R.
#   -q  Wrap PostgreSQL identifiers in quotes.
#   -I  Create a GIST spatial index on the raster column. The ANALYZE
#       command will automatically be issued for the created index.
#   -M  Run VACUUM ANALYZE on the table of the raster column. Most
#       useful when appending raster to existing table with -a.
#   -C  Set the standard set of constraints on the raster
#       column after the rasters are loaded. Some constraints may fail
#       if one or more rasters violate the constraint.
#   -x  Disable setting the max extent constraint. Only applied if
#       -C flag is also used.
#   -r  Set the constraints (spatially unique and coverage tile) for
#       regular blocking. Only applied if -C flag is also used.
#   -T <tablespace> Specify the tablespace for the new table.
#       Note that indices (including the primary key) will still use
#       the default tablespace unless the -X flag is also used.
#   -X <tablespace> Specify the tablespace for the table's new index.
#       This applies to the primary key and the spatial index if
#       the -I flag is used.
#   -N <nodata> NODATA value to use on bands without a NODATA value.
#   -k  Keep empty tiles by skipping NODATA value checks for each raster band. 
#   -E <endian> Control endianness of generated binary output of
#       raster. Use 0 for XDR and 1 for NDR (default). Only NDR
#       is supported at this time.
#   -V <version> Specify version of output WKB format. Default
#       is 0. Only 0 is supported at this time.
#   -e  Execute each statement individually, do not use a transaction.
#   -Y <max_rows_per_copy> Use COPY statements instead of INSERT statements. 
#     Optionally specify <max_rows_per_copy>; default 50 when not specified. 
#   -G  Print the supported GDAL raster formats.
#   -?  Display this help screen.
# 