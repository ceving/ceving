DBFILE := data.sqlite3
SQLFILE := data.sql

ifeq ("$(wildcard $(SQLFILE))","")
MISSING := $(SQLFILE)
endif

ifeq ("$(wildcard $(DBFILE))","")
MISSING := $(DBFILE)
endif

all: $(MISSING)

show: $(DBFILE)
	sqlite3 $< 'select rowid as id,* from person order by lastname'

ifeq ("$(wildcard $(SQLFILE))","")
$(SQLFILE): $(DBFILE)
	sqlite3 $< .dump > $@
endif

ifeq ("$(wildcard $(DBFILE))","")
$(DBFILE): $(SQLFILE)
	sqlite3 $@ < $<
endif
