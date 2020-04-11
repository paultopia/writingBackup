# writingBackup

This is a very small opinionated personal commandline tool for backing up markdown-formatted academic writing in git repositories somewhere else. 

Early beta, might blow up, doesn't have any options at all yet, minimal tests and only for the happy path, etc. etc.

## Why? 

Because I personally like to do much of my longer academic writing in markdown format inside Git repositories, with a bunch of different MD files and pandoc + zotero to build output.  (For other academic types, Kieran Healy has [some nice advocacy and tutorial for this kind of workflow](https://kieranhealy.org/resources/).)  

But I'm paranoid about backups, and merely backing up onto GitHub does not feel like enough to me (especially since Microsoft now owns Github).  I'd like to be able to also back up the latest versions of my text to a running file in some other place, such as in a Dropbox or Google Drive folder.  

Unfortunately, [conventional wisdom](https://www.anishathalye.com/2015/08/19/git-remote-dropbox/) is that it's a bad idea to stick a Git repo in a Dropbox folder because whatever black magic Dropbox uses to sync might screw up version control. And I'm sure the same goes for the other major cloud services. 

Hence, this workaround.

## What Does it Do?

You give it a config file (details below).  It takes all the markdown files that you ask it to back up, concatenates them in the given order, uses Pandoc to fill in citations if you got 'em, and then copies the concatenated, cites-added, file in markdown format to a designated backup location (overwriting the previous backup). That way, if your hard drive melts down and for whatever reason you can't get the files off Github (or Gitlab, or BitBucket, or whev) either, you'll have one file with all your work as of the last backup in your Dropbox/Gdrive/OneDrive/Box/whev.

## How to use? 

1.  Put the binary release (see the releases tab) of this thing somewhere on your PATH. Rename it whatever you want (I was tempted to name this whole thing "backup," but that feels like a thing that would clash with other names, so we'll just pretend it's called writingBackup like in the releases.) and make sure it's executable.

2.  Put a file called `backup.toml` in the root folder of the repository containing your writing. This is your config file, it should contain the following: 

	a.  An array called `inFiles` listing every markdown file to back up, in order you want them to appear in the combined file, as relative paths from the root of the directory. Actually, absolute paths probably would work too, but I haven't tested.

	b.  A string called `outFile` with a path to the destination markdown file.  Tilde expansion (e.g. ~/Dropbox/MyBackups/GreatPaperBackup.md) works.

	c.  (Optional) A string called `bibFile` with a path to bibliography in any format that Pandoc can parse (bibTeX, CSL JSON, etc. etc.). 

To see an example of a correctly formatted config file, see [here](Tests/writingBackupTests/testfiles/backup.toml).

## What else do I need?

- Pandoc and Pandoc-citeproc should be installed on your system.

- I've only tested this on my machine, which runs MacOS 10.14.6, so dunno if it will work on some other version of MacOS or on Linux (it definitely won't work on windows)

(actually, you shouldn't need pandoc if you don't want citations, as I seriously just am using it for citations, but the lazy way I have the code currently written pipes everything through pandoc to go from markdown to markdown anyway, because I almost always want citations personally.  Plus I guess Pandoc is probably going to be nice enough to clean up one's markdown.  And maybe one day I'll add an option to switch to a different format, or not use pandoc..)  

## Legal and Credits

MIT License.  

Some of the code (for getting pandoc to run) adapted (i.e., swiped) from [https://github.com/RockfordWei/PanDoc](https://github.com/RockfordWei/PanDoc), which doesn't have a license listed, but last I recall (I think) the GitHub user agreement opts one in to a default of the MIT license for public repos without any other license so I'm relying on that. 
 
Architecture for getting it to work using commandline app structure suggested by [Sundell](https://www.swiftbysundell.com/articles/building-a-command-line-tool-using-the-swift-package-manager/). 

To repeat, early beta, might blow up, doesn't have any options at all yet, minimal tests and only for the happy path, etc. etc. No warranties, you assume the risk if it deletes all your data or blows up your computer or something. 


