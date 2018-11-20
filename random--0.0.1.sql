\echo Use "CREATE EXTENSION random" to load this file. \quit

create or replace function random.shuffle(population anyarray) returns anyarray as $$
    select array_agg(c) from (select c from unnest(population) c order by random()) d;
    $$ language sql;

create or replace function random.choices(population anyarray, weights numeric[], k integer, out result anyarray) as $$
    begin
        assert array_length(population, 1) = array_length(weights, 1), 'population and weights array length must be the same';

        for i in 1..array_length(population, 1) loop
            for j in 1..weights[i] loop
                result := result || population[i];
            end loop;
        end loop;
        result := random.choices(result, k);
        return;
    end
    $$ language plpgsql;

create or replace function random.choices(population anyarray, k integer) returns anyarray as $$
    select array_agg(c) from (select c from unnest(population) c order by random() limit k) d;
    $$ language sql;

create or replace function random.choice(anyarray) returns anyelement as $$
    select (random.choices($1, 1))[1];
    $$ language sql;

create or replace function random.randrange(start integer, stop integer, step integer default 1) returns integer as $$
    select start + step * trunc(random() * trunc(1 + (stop - start) / step))::integer
    $$ language sql;

create or replace function random.randrange(stop integer) returns integer as $$
    select random.randrange(0, stop);
    $$ language sql;

create or replace function random.randrange(start date, stop date, step integer) returns date as $$
    select start + step * trunc(random() * trunc(1 + (stop - start) / step))::integer
    $$ language sql;

create or replace function random.randrange(start date, stop date, step interval) returns date as $$
    select start + extract(day from step)::integer * trunc(random() * trunc(1 + (stop - start) / extract(day from step)))::integer
    $$ language sql;

create or replace function random.randrange(start timestamp, stop timestamp, step interval) returns timestamp as $$
    select start + step * trunc(random() * trunc(extract(epoch from stop - start) / extract(epoch from step)))::integer
    $$ language sql;

create or replace function random.randrange(start timestamp with time zone, stop timestamp with time zone, step interval) returns timestamp with time zone as $$
    select start + step * trunc(random() * trunc(extract(epoch from stop - start) / extract(epoch from step)))::integer
    $$ language sql;

create or replace function random.uniform(integer, integer) returns double precision as $$
    /* Return a random integer between a and b, inclusive */
    select random() * ($2 - $1 + 1) + $1;
    $$ language sql;

create or replace function random.uniform(real, real) returns real as $$
    /* Return a random integer between a and b, inclusive */
    select (random() * ($2 - $1) + $1)::real;
    $$ language sql;

create or replace function random.uniform(double precision, double precision) returns double precision as $$
    /* Return a random integer between a and b, inclusive */
    select (random() * ($2 - $1) + $1)::double precision;
    $$ language sql;

create or replace function random.uniform(timestamp, timestamp) returns timestamp as $$
    /* Return a random integer between a and b, inclusive */
    select make_interval(secs := random() * extract(epoch from $2 - $1)) + $1
    $$ language sql;

create or replace function random.uniform(timestamp with time zone, timestamp with time zone) returns timestamp with time zone as $$
    /* Return a random integer between a and b, inclusive */
    select make_interval(secs := random() * extract(epoch from $2 - $1)) + $1
    $$ language sql;

create or replace function random.triangular(low double precision default 0.0, high double precision default 1.0, mode double precision default null) returns numeric as $$
    declare
        u float;
        c float;
        final_low float;
        final_high float;
    begin
        u := random();
        if mode is null then
            c := 0.5;
        else
            c := (mode - low)::float / (high - low);
        end if;

        if u > c then
            u := 1.0 - u;
            c := 1.0 - c;
            final_low := high;
            final_high := low;
        else
            final_low := low;
            final_high := high;
        end if;
        return final_low + (final_high - final_low) * |/ (u * c);
    end;
    $$ language plpgsql;

create or replace function random.triangular(low numeric default 0, high numeric default 1, mode double precision default null) returns numeric as $$
    select random.triangular(low::float, high::float, mode);
    $$ language sql;

create or replace function random.triangular(low timestamp with time zone, high timestamp with time zone, mode timestamp with time zone) returns timestamp with time zone as $$
    select to_timestamp(random.triangular(extract(epoch from low), extract(epoch from high), extract(epoch from mode)));
    $$ language sql;
