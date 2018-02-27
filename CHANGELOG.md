# Changelog

## **2018.02.27**

* Add only_columns
* Update tests for ActiveAdmin 1.2

## **2018.02.19**

* fix unnecessary database access
* update tests

## **2013.10.12**

by [@randym][]

* Upgraded to most recent version of Axlsx. This introduces some non-backwards compatible
  changes and pushes rubyzip up to 1.0.0
* Added support for scoped collections #18
* Added support to specify whitelist in in configuration. This will clear all columns and
  you can then specify only the fields you want.
* Added support for skip_header in the builder/DSL.
* Moved initialization into after config block in an attempt to not crunch assets:precompile

## **2013.06.02** Release 2.1.2

by [@randym][]

* builder#collection is now set on serialize and is available in before and after filters.
* Code cleanup

## **2013.04.18** Release 2.1.1

by [@randym][]

* Fixed issue with repeating data in sheets across downloads
* Updated to use activeadmin 0.6.0+ which supports plugins.

## **2013.03.21** Release 2.0.1

by [@randym][]

* Fixed an issue with missing objects when using the DSL.
  Huge thanks to [@fivell][]

## **2012.11.29** Release 2.0.0

by [@randym][]

* resouce content column are now pre-populated.
* added before and after filters
* 100% spec coverage

## **2012.11.16**

by [@randym][]

* Fixed DSL referencing
* Added delete_columns to builder and DSL

[@randym]: https://github.com/randym
[@fivell]: https://github.com/fivell