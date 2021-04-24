# Release Workflow
Before submitting a new release, make sure all relevant pull requests and local branches have been merged to the `master`
branch. All tests must pass before a release is tagged.


## 1. Puppet Development Kit
If not installed, please install the PDK and do a 'bundle install'.
``` bash
pdk bundle install
```
Or if already installed do an update.
``` bash
pdk bundle update
```

## 2. AUTHORS
Update the [AUTHORS] and [.mailmap] file

``` bash
git checkout master
git log --use-mailmap | grep ^Author: | cut -f2- -d' ' | sort | uniq > AUTHORS
git commit -am "Update AUTHORS"
```

## 3. Reference
If it is not installed [puppet-strings]:
``` bash
gem install puppet-strings --no-ri --no-rdoc
```
Generate [REFERENCE.md] via [Puppet Strings]
``` bash
puppet strings generate --format markdown --out ./REFERENCE.md
```

## 4. Version
Version numbers are incremented regarding the [SemVer 1.0.0] specification. 
Update the version number in `metadata.json`.

## 5. Changelog
Install [github-changelog-generator]
```bash
gem install github_changelog_generator -v 1.13.2
```

Generate [CHANGELOG.md]
```bash
github_changelog_generator -t <github-access-token> --future-release=v1.0.0 -u icinga -p puppet-icinga2
```

## 6. Git Tag
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

## 7. Build and Upload
``` bash
pdk build
```
Upload the tarball to Puppet Forge.

[github-changelog-generator]: https://github.com/skywinder/github-changelog-generator
[Puppet Strings]: https://puppet.com/docs/puppet/5.5/puppet_strings.html
[SemVer 1.0.0]: http://semver.org/spec/v1.0.0.html
[CHANGELOG.md]: CHANGELOG.md
[AUTHORS]: AUTHORS
[.mailmap]: .mailmap
[forge.puppet.com]: https://forge.puppet.com/
