# urbit-sync

## THIS PROJECT IS NOW OFFICIALLY DEPRECATED
and I will no longer be updating or maintaing it. In the course of working on this last multi-pier work I discovered to my chagrin that it is far easier to just use `rsync`.

Still, it was fun while it lasted. :)

## About
Initializes and Synchronizes your local filesystem and your mounted urbit pier.

I created this because it was useful for me at this very early stage of
urbit's life. It lets me check out the repos I am working on and not worry
about keeping the files in sync. It also lets me define the
packages that I am including in my base pier setup so when one
crashes, getting another one fully  set up is a single command.

> DISCLAIMER:
>
>  It is *not* a substitute for an urbit package management system.
>  ~rophex-hashes has been doing some great early work on a prototype for this
>  called urbit-package. See  [this post on
>  fora](https://urbit.org/fora/posts/~2017.9.7..23.20.06..dc47~/) and [the
>  github repository](https://github.com/asssaf/urbit-package).


[Urbit Fora Post for Discussion](https://urbit.org/~~/fora/posts/~2017.9.29..11.58.54..4dd1~)

## Installation

- If you don't have it already, install ruby any way you prefer. This was
developed using ruby 2.4.1 and if you're using rbenv it will try to use that
version automatically via the .ruby-version file in the root of the project.

- Install Bundler

```
$ gem install Bundler
```

- Install all dependencies. There's not that many

```
$ bundle install
```

- Copy _config.yml.example into _config.yml and edit it to match your
configuration. See the configuration guide below.

- Initialize all the files:

```
$ bundle exec ./urbsync.rb --init

"Initializing all watch directories"
"Excluded, not copied --> .DS_Store"
"Excluded, not copied --> .git"
"Excluded, not copied --> .gitignore"
"--> cp -af /Users/drichter/Code/urbit-docs/docs ~/urbits/fake-zod/home/web/"
"--> cp -af /Users/drichter/Code/urbit-docs/docs.md ~/urbits/fake-zod/home/web/"
"Excluded, not copied --> readme.md"
"Excluded, not copied --> .git"
"--> cp -af /Users/drichter/Code/zaxlog/blog ~/urbits/fake-zod/home/web/"
"--> cp -af /Users/drichter/Code/zaxlog/blog.md ~/urbits/fake-zod/home/web/"
"Excluded, not copied --> README.md"
```

- Start the sync:

```
bundle exec ./urbsync.rb

"Synchronizing all watch directories..."
```

- Work!

## Program Options

```
$ bundle exec ./urbsync.rb --help

Usage: urbsync [options]
    -i, --init              Initialize all watch directories and exit
    -v, --verbose           Prints all operations to the console.
```


## Configuration Guide

All of the available sections are illustrated in _config.yml.example. Here are
descriptions of what each does:

**watch_dirs** : this is a list of the directories that you want to sync to
your urbit. Note that these need to be full paths and you can't use ~ as a
shortcut. You may need adapt the path based upon the git repo you are using.

For example, if you are using [~rophex-hashes' urbit-extra-marks
repo](https://github.com/asssaf/urbit-extra-marks) you will notice that all the
files you want to copy are in the /src sub-directory. If you had it checked out
to /home/ec2-user/source (perhaps because you used [my urbit-devops
project](https://github.com/ngzax/urbit-devops) to set up your urbit. plug!),
the entry for watch_dir would look like so:

```
'/home/ec2-user/source/urbit-extra-marks/src'
```

**excluded_files** : Put the file names of files you don't want to sync here.
Right now this is valid across all watch_dirs.

**desks** : This is a list which needs to be in the same order as the
watch_dirs and it defines which desk you want each watch_dir sync'ed to.

**paths** : This is the path within the desk above that you want the files
copied to. This also needs to be in the same order as the watch_dirs. If you
just want to sync to the root, use ''.

**pier** : The fully qualified path to the pier that you want to sync to.


## Contributing

I would appreciate contributions to urbit-sync.

Everyone involved in the **urbit-sync** project needs to understand and
respect our Code of Conduct,  which has been shamelessly and appropriately
borrowed in its entirety from [urbit][2]:

> "don't be rude."

If you can code and abide by the simple Code of Conduct, fork the repo and submit a PR. I will review it as soon as I can.

There is a list of requested features and bugs [in the issue tracker][1].


## License

"urbit-sync" is copyright (c) 2017 by Daryl Richter (ngzax).

urbit-sync source code is released under the MIT License.

Check the [LICENSE](LICENSE) file for more information.


[1]: https://github.com/ngzax/urbit-sync/issues
[2]: https://github.com/urbit/urbit
