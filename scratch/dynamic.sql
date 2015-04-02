-- A type is a name with a unique number.
CREATE TABLE type (
  id INTEGER PRIMARY KEY,
  name TEXT
);

-- A record has a unique number and a type and zero or more values.
CREATE TABLE record (
  id INTEGER PRIMARY KEY,
  type INTEGER,
  FOREIGN KEY(type) REFERENCES type(id)
);

-- A value has a unique number, may belongs to a record, has a syntactically
-- type and a lexical type and contains some data, which is either text, 
-- encoded content or a reference to a record.  Data references are not
-- enforced, they are virtually symbolic links.
CREATE TABLE value (
  id INTEGER PRIMARY KEY,
  record INTEGER,
  type2 INTEGER,  -- syntactically, Chomsky type-2
  type3 INTEGER,  -- lexical, Chomsky type-3
  data,           -- SQLite's NONE affinity
  FOREIGN KEY(record) REFERENCES record(id),
  FOREIGN KEY(type2) REFERENCES type(id),
  FOREIGN KEY(type3) REFERENCES type(id)
);
