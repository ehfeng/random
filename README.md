# Random

Experiment in duplicating [Python's random module](https://docs.python.org/3/library/random.html) in SQL/plpgSQL functions. The functions can be useful in hosted Postgres environments, where you can manually run the file to have access to these functions.

If you have the ability to install extensions, you likely can just `create language plpython3u`, which will give you direct access to the Python random module, which is a better approach.

## Usage

```sql
select random.shuffle('{1,2,3,4,5,6}'::integer[]);
select random.choice('{1,2,3,4,5}'::integer[]);
select random.choice('{"a", "b", "c"}'::text[]);
select random.choices('{"a", "b", "c"}'::text[], 2);
select random.choices('{"a", "b", "c"}'::text[], 2);
select random.choices('{"a", "b", "c"}'::text[], '{1,2,3}'::integer[], 2);
select random.randrange(1, 10, 2);
select random.randrange(6);
select random.randrange('2018-10-01'::date, '2018-11-01'::date, 7);
select random.randrange('2018-10-01'::timestamp, '2018-11-01'::timestamp, '7 day'::interval);
select random.uniform(3, 6);
select random.uniform(1.6, 3.9);
select random.uniform('2018-10-01'::timestamp, '2018-10-02'::timestamp);
select random.triangular(0, 1, 1);
```

## Install

Clone repo and `make install`

Within database, `create extension random;`

## Notes

`random.choices` does not accept a cumulative weight option.

More complex functions like `random.betavariate`, `random.expovariate`, `random.gammavariate` were not implemented.
