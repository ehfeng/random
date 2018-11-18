\echo Use "CREATE EXTENSION random" to load this file. \quit

create or replace function randrange(start integer, stop integer, step integer) returns integer as $$
    select start + trunc(random() * step * (stop - start))::integer;
    $$ language sql;

create or replace function randrange(start integer, stop integer) returns integer as $$
    select randrange(start, stop, 1);
    $$ language sql;

create or replace function randrange(stop integer) returns integer as $$
    select randrange(0, stop);
    $$ language sql;

create or replace function choice(text[]) returns text as $$
    select $1[ceil(random() * array_length($1, 1))];
    $$ language sql;

create or replace function choice(integer[]) returns integer as $$
    select $1[ceil(random() * array_length($1, 1))];
    $$ language sql;

create or replace function choice(double precision[]) returns double precision as $$
    select $1[ceil(random() * array_length($1, 1))];
    $$ language sql;

create or replace function choice(timestamp[]) returns timestamp as $$
    select $1[ceil(random() * array_length($1, 1))];
    $$ language sql;

create or replace function choice(date[]) returns date as $$
    select $1[ceil(random() * array_length($1, 1))];
    $$ language sql;

-- create or replace function choices(text[], integer[], integer) as $$
--     $$ language sql;

-- create or replace function shuffle(text[]) as $$
--     $$ language sql;

-- create or replace function sample(text[], integer) as $$
--     $$ language sql;

create or replace function uniform(integer, integer) returns double precision as $$
    /* Return a random integer between a and b, inclusive */
    select random() * ($2 - $1 + 1) + $1;
    $$ language sql;

create or replace function uniform(real, real) returns real as $$
    /* Return a random integer between a and b, inclusive */
    select (random() * ($2 - $1) + $1)::real;
    $$ language sql;

create or replace function uniform(double precision, double precision) returns double precision as $$
    /* Return a random integer between a and b, inclusive */
    select (random() * ($2 - $1) + $1)::double precision;
    $$ language sql;

create or replace function uniform(timestamp, timestamp) returns timestamp as $$
    /* Return a random integer between a and b, inclusive */
    select make_interval(secs := random() * extract(epoch from $2 - $1)) + $1
    $$ language sql;