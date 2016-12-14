# Release Workflow
Before submitting a new release, make sure all relevant pull requests and local branches have been merged to the `master`
branch. All tests must pass before a release is tagged.


## 1. AUTHORS
Update the [AUTHORS] and [.mailmap] file

``` bash
git checkout master
git log --use-mailmap | grep ^Author: | cut -f2- -d' ' | sort | uniq > AUTHORS
git commit -am "Update AUTHORS"
```

## 2. Changelog
We currently don't have any automation to generate the content of [CHANGELOG]. A possible way to collect all changes made
since the last version is to look at the merged pull requests. Issue numbers in branch will lead you also to the relevant
tickets on [dev.icinga.com].

## 3. Version
Version numbers are incremented regarding the [SemVer 1.0.0] specification. 
Update the version number in `metadata.json`.

## 4. Git Tag
Commit all changes to the `master` branch

``` bash
git commit -v -a -m "Release version <VERSION>"
git push
```

Tag the release

``` bash
git tag -m "Version <VERSION>" v<VERSION>
```

Push tags

``` bash
git push --tags
```


## Puppet Forge
TODO: Write Puppet Forge workflow.

[SemVer 1.0.0]: http://semver.org/spec/v1.0.0.html
[CHANGELOG]: CHANGELOG
[dev.icinga.com]: https://dev.icinga.com/puppet-icinga2-rewrite
[AUTHORS]: AUTHORS
[.mailmap]: .mailmap
