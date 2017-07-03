## База данных lists.memo.ru (она же "база с диска") лежит вот тут в сконвертированном виде https://github.com/MemorialInternational/memorial_data/tree/master/data/lists.memo.ru-disk 

Она приведена в нормализованной форме в архиве `lists.memo.ru-disk.zip` (дамп базы с диска), а также в виде единой таблицы в файле `memorial_lists.tsv.7z` (сконвертировано из дампа - см. [замечания о процессе конвертации](https://github.com/VorontsovIE/memorial_data_FULL_DB/blob/master/data/lists.memo.ru-disk/conversion_notes.md).

memorial-data
=============

Data from Memorial (http://memo.ru) in machine readable form:

* victims of terror of 1930s in Moscow
* lists of 2614978 victims across Russia
* geodata for objects of terror

##mos.memo.ru

Scraped from source: http://mos.memo.ru

Main datafile is: data/mos.memo.ru/all.csv, includes addresses.

Includes downloading and parsing script.

Portion of these data (Lubyanka area) was geocoded and put on the map here: http://october29.ru/wp/gorod/

License: code - GNU GPL v2 or any later version, data - unknown, possibly CC-BY

Related links:

* Lubyanka Web-GIS sources: https://github.com/nextgis/memo-oct29
* First try at geocoding in 2001 (not good, but first) - Rivers of blood in Moscow:The Great Purge personified http://memoryfull.ru/purge/repressions.html, data: https://www.google.com/fusiontables/DataSource?snapid=S179582JJFj

##lists.memo.ru-disk

Data extracted from the MySQL database distributed on ["Жертвы политического террора в СССР"](http://rutracker.org/forum/viewtopic.php?t=1185307) disk.

Main datafiles are: data/lists.memo.ru-disk, no addresses

License: unknown, possibly CC-BY

Related links:

* [Installing database](https://github.com/nextgis/memorial-data/wiki/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-%D0%B1%D0%B0%D0%B7-%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85-%D0%B8%D0%B7-lists.memo.ru)
* [Converting database](https://github.com/nextgis/memorial-data/wiki/%D0%9A%D0%BE%D0%BD%D0%B2%D0%B5%D1%80%D1%82%D0%B0%D1%86%D0%B8%D1%8F-%D0%B1%D0%B0%D0%B7-%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85)
* Another project on extracting full lists throughout Russia by web-scrapping (but no address information): https://github.com/ivbeg/memoru

##topography of terror

Geodata used on the 'Topography of terror' map: http://topos.memo.ru/karta. License: ODbL (OpenStreetMap is a source for building outlines).

Related links:

* [Software component for Topography of terror project](https://github.com/nextgis/topography-of-terror). 
* [Old<->New street names used for a map](https://github.com/nextgis/topography-of-terror/blob/master/DB%20sources/streets_names.csv)
