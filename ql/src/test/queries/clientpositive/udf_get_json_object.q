set hive.fetch.task.conversion=more;

DESCRIBE FUNCTION get_json_object;
DESCRIBE FUNCTION EXTENDED get_json_object;

CREATE TABLE dest1_n66(c1 STRING) STORED AS TEXTFILE;

FROM src INSERT OVERWRITE TABLE dest1_n66 SELECT '  abc  ' WHERE src.key = 86;

set hive.fetch.task.conversion=more;

EXPLAIN
SELECT get_json_object(src_json.json, '$.owner') FROM src_json;

SELECT get_json_object(src_json.json, '$') FROM src_json;

SELECT get_json_object(src_json.json, '$.owner'), get_json_object(src_json.json, '$.store') FROM src_json;

SELECT get_json_object(src_json.json, '$.store.bicycle'), get_json_object(src_json.json, '$.store.book') FROM src_json;

SELECT get_json_object(src_json.json, '$.store.book[0]'), get_json_object(src_json.json, '$.store.book[*]') FROM src_json;

SELECT get_json_object(src_json.json, '$.store.book[0].category'), get_json_object(src_json.json, '$.store.book[*].category'), get_json_object(src_json.json, '$.store.book[*].isbn'), get_json_object(src_json.json, '$.store.book[*].reader') FROM src_json;

SELECT get_json_object(src_json.json, '$.store.book[*].reader[0].age'), get_json_object(src_json.json, '$.store.book[*].reader[*].age')  FROM src_json;

SELECT get_json_object(src_json.json, '$.store.basket[0][1]'), get_json_object(src_json.json, '$.store.basket[*]'), get_json_object(src_json.json, '$.store.basket[*][0]'), get_json_object(src_json.json, '$.store.basket[0][*]'), get_json_object(src_json.json, '$.store.basket[*][*]'), get_json_object(src_json.json, '$.store.basket[0][2].b'), get_json_object(src_json.json, '$.store.basket[0][*].b') FROM src_json;

SELECT get_json_object(src_json.json, '$.non_exist_key'),  get_json_object(src_json.json, '$..no_recursive'), get_json_object(src_json.json, '$.store.book[10]'), get_json_object(src_json.json, '$.store.book[0].non_exist_key'), get_json_object(src_json.json, '$.store.basket[*].non_exist_key'), get_json_object(src_json.json, '$.store.basket[0][*].non_exist_key') FROM src_json;

SELECT get_json_object(src_json.json, '$.zip code') FROM src_json;

SELECT get_json_object(src_json.json, '$.fb:testid') FROM src_json;


-- Verify that get_json_object can handle new lines in JSON values

CREATE TABLE dest2_n14(c1 STRING) STORED AS RCFILE;

INSERT OVERWRITE TABLE dest2_n14 SELECT '{"a":"b\nc"}' FROM src tablesample (1 rows);

SELECT * FROM dest2_n14;

SELECT get_json_object(c1, '$.a') FROM dest2_n14;

--root is array
SELECT
get_json_object('[1,2,3]', '$[0]'),
get_json_object('[1,2,3]', '$.[0]'),
get_json_object('[1,2,3]', '$.[1]'),
get_json_object('[1,2,3]', '$[1]'),
get_json_object('[1,2,3]', '$[2]'),
get_json_object('[1,2,3]', '$[*]'),
get_json_object('[1,2,3]', '$'),
get_json_object('[{"k1":"v1"},{"k2":"v2"},{"k3":"v3"}]', '$[2]'),
get_json_object('[{"k1":"v1"},{"k2":"v2"},{"k3":"v3"}]', '$[2].k3'),
get_json_object('[[1,2,3],[4,5,6],[7,8,9]]', '$[1]'),
get_json_object('[[1,2,3],[4,5,6],[7,8,9]]', '$[1][0]'),
get_json_object('[{"k1":[{"k11":[1,2,3]}]}]', '$[0].k1[0].k11[1]');

--null
SELECT
get_json_object('[1,2,3]', '[2]'),
get_json_object('[1,2,3]', '$0'),
get_json_object('[1,2,3]', '$[3]');