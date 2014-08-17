# puppet-icinga2 Installation

## Installing the Puppet Module

Put it in your modules directly and configure your manifest.

## Building Release Tarballs

In order to build a release tarball you should first check out the Git repository
in a new directory. If you're using an existing check-out you should make sure
that there are no local modifications:

$ git status

Here's a short check-list for releases:

* Update the .mailmap and AUTHORS files
    $ git log --use-mailmap | grep ^Author: | cut -f2- -d' ' | sort | uniq > AUTHORS
* Bump the version in metadata.json.
* Update the ChangeLog file.
* Commit these changes to the "master" branch and create a signed tag (tags/v<VERSION>).
    $ git commit -v -a -m "Release version <VERSION>"
    $ git tag -u EE8E0720 -m "Version <VERSION>" v<VERSION>
    $ git push --tags
* Merge the "master" branch into the "support/2.0" branch (using --ff-only).
    $ git checkout support/2.0
    $ git merge --ff-only master
    $ git push origin support/2.0
* Bump the version to "v<NEXT-VERSION>-dev" and commit this change to the "master" branch.

Use "git archive" to build the release tarball:

$ VERSION=2.0.0
$ git archive --format=tar --prefix=puppet-icinga2-$VERSION/ tags/v$VERSION | gzip >puppet-icinga2-$VERSION.tar.gz

Finally you should verify that the tarball only contains the files it should contain:

$ VERSION=2.0.0
$ tar ztf puppet-icinga2-$VERSION.tar.gz | less
