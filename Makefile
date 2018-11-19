EXTENSION = random
DATA = random--0.0.1.sql
REGRESS = test_random

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)