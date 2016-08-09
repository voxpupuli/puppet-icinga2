# Release Workflow
Before submitting a new release, make sure all relevant pull requests and local branches have been merged to the `master`
branch.

## Version
Version numbers are incremented regarding the [SemVer 1.0.0] specification. 
Update the version number in `metadata.json`.

## Changelog
We currently don't have any automation to generate the content of [CHANGELOG]. A possible way to collect all changes made
since the last version is to look at the merged pull requests. Issue numbers in branch will lead you also to the relevant
tickets on [dev.icinga.org].

## AUTHORS
Update the [AUTHORS] and [.mailmap] file

```
git checkout master
git log --use-mailmap | grep ^Author: | cut -f2- -d' ' | sort | uniq > AUTHORS
git commit -am "Update AUTHORS"
```

## Git Tag
Commit all changes to the `master` branch

```
git commit -v -a -m "Release version <VERSION>"
```

Tag the release

```
git tag -m "Version <VERSION>" v<VERSION>
```

Push tags

```
git push --tags
```


## Puppet Forge
TODO: Write Puppet Forge workflow.

[SemVer 1.0.0]: http://semver.org/spec/v1.0.0.html
[CHANGELOG]: CHANGELOG
[dev.icinga.org]: https://dev.icinga.org/puppet-icinga2-rewrite
[AUTHORS]: AUTHORS
[.mailmap]: .mailmap