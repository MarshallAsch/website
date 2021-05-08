---
layout: post
title: My journey with dracut and the emergency shell
subtitle: Breaking my computer, again
tags: [os, grub, fedora, storage]
categories: blog
comments: true
readtime: true
---

# Where it all began

This all begins nearly a year ago when I build and setup my desktop.
It was a nice opportunity to try out several different OS's (different linux flavours of course),
and windows managers, and a general period of trying out new things and inevitably breaking things.
I knew that going into it and I was prepared, I got setup, I installed Fedora31, Fedora33, and a couple others.
I decided when I installed them 'I shall put them each in their own physical disk partition so it will be easy to get rid of it when I am done / inevitably mess up', and I set them up using LVM partitions.
They were setup with a separate `/root` and `/home`, 60GB and 100GB respectively with an extra 10GB just in case I need to add more.
So far so good right?
That is what I thought.

Fast forward several months as I am going about my day installing [Docker], which had just received support for cgroups v2.
Then suddenly **boom**, I got the `Low disk space on filesystem root` error message.
Okay this is not horrible, I left myself 10GB of extra space just incase something like this happened.
A few quick googles later and I ran:

```bash
$ sudo lvextend -L+10G /dev/mapper/fedora33-root
$ sudo resize2fs /dev/mapper/fedora33-root
$ df -h
...
/dev/mapper/fedora33-root         60G   70G   10G  85% /
...
```

That looks good right?
I reboot my computer and it still turns on and I am happy (is this foreshadowing the future? read on to find out).
My problem is solved, I have more storage space life is good, 10GB isn't much but it should be enough to last me a while while I figure out what I can do about the problem.

**Note: Since I am writing this well after the events have happened the volume names and sizes may not be correct or match up 100% of the time, but I'm trying to be close enough for the important stuff**


About a week later I remembered that I still had those old 'temporary' OS installations laying around on my disk, and I wanted to check to see what was on the other ones so I can take what I want and delete them later when I have no more plans on using it.
So I did the first step that one would need to mount the file system, figure out what they are called.
I know that all the lvm volumes are `/dev/mapper/<something>` devices so I am limiting the list to just those.

```bash
$ sudo fdisk -l | grep mapper
Disk /dev/mapper/fedora33--image-root:          70 GiB, 128849018880 bytes, 251658240 sectors
Disk /dev/mapper/fedora33-home:         100 GiB, 214748364800 bytes, 419430400 sectors
Disk /dev/mapper/localhost--image-root:  70 GiB, 128849018880 bytes, 251658240 sectors
Disk /dev/mapper/localhost--image-home: 110 GiB, 214748364800 bytes, 419430400 sectors
Disk /dev/mapper/localhost-image-root:   50 GiB, 128849018880 bytes, 251658240 sectors
Disk /dev/mapper/localhost-image-home:   50 GiB, 214748364800 bytes, 419430400 sectors
```

Well this doesn't look right, how do I know which one is which? I shall fix this (famous last words).
According to the RedHat [LVM documentation] renaming should be super simple:

```bash
$ sudo vgrename fedora33--image fedora33
$ sudo vgrename localhost--image fedora31
$ sudo vgrename localhost-image  other
```

Nice and easy, and then we check to make sure that it worked
```bash
$ sudo fdisk -l | grep mapper
Disk /dev/mapper/fedora33-root:          70 GiB, 128849018880 bytes, 251658240 sectors
Disk /dev/mapper/fedora33-home:         100 GiB, 214748364800 bytes, 419430400 sectors
Disk /dev/mapper/fedora31-root:          70 GiB, 128849018880 bytes, 251658240 sectors
Disk /dev/mapper/fedora31-home:         110 GiB, 214748364800 bytes, 419430400 sectors
Disk /dev/mapper/other-root:             50 GiB, 128849018880 bytes, 251658240 sectors
Disk /dev/mapper/other-home:             50 GiB, 214748364800 bytes, 419430400 sectors
```

That looks much better, now I just have one more task to do to make sure that the computer is still able to turn on after these changes (or so I think).
Update `/etc/fstab` with the correct device paths so it can mount the file systems.

```bash
$ cat /etc/fstab
...
/dev/mapper/fedora33--image-root /                       ext4    defaults        1 1
/dev/mapper/fedora33--image-home /home                   ext4    defaults        1 2
...
```

Edit this file that it looks like:
```
...
/dev/mapper/fedora33-root /                       ext4    defaults        1 1
/dev/mapper/fedora33-home /home                   ext4    defaults        1 2
...
```

Excellent, we can now reboot the machine and all will be fantastic and the names of the volumes will make sense.



![Dracut shell screen shot](/assets/img/dracut-shell.jpg)
_Image taken from [fedora magazine dracut]_


## And so the horror of the emergency shell begins

When this first happened I was extremely confused, I had absolutely no idea what the emergency shell was.
In fact no one I know in my friend group had any idea what it was or had even heard of it before,
and they mess with their machines even more than I do.
This was a very very very bad sign.

After several hours of googling, spread out across two days, because of course I started this whole fiasco at 7pm,
I was unable to solve the problem using the emergency shell.
The solution for me at the time was to boot into a bootable USB, rebuild GRUB, rebuild the initRAMFS, and it magically worked.
The commands that I ran were some sort of dark magic that mysteriously worked for reasons unknown to me, and I was happy because my computer turned on again.


Fantastic, I never have to worry about this problem again, because really how often am I going to be messing with my disks?.......



# A couple of months later....

So remember that problem where I ran out of storage space and I added 10 more gigabytes of space to my root file system and said I'll do a better fix later?
Remember how I thought that I would not have to mess with my disks again?
Well it turns out I forgot about that and did not fix it.
Do you see where this might be going? ...

Guess what, the problem has surfaced once again.

Once again I went to test out some of my [simulation code] for my thesis, and **kaboom** out of storage space.
Okay, _this time_ I shall fix it properly.
I got prepared and did m googling _before_ I started messing with things and thought I had a pretty solid plan.
One thing to note before I continue with this is that I am fully aware that everything I am about to do would be
about a million times easier if I just shutdown the machine and boot unto a different OS and make all these changes from there.
But, I wanted to try and learn something new and do all of this while the machine is still running.

### The plan

1. Make a frickin backup of everything I care about
2. delete the old LVM volumes, groups, and physical volumes of the unused OS
3. delete the physical partitions that those are on
4. extend the physical partition
    1. list _all_ of the partition information
    2. delete the partition
    3. create a new partition
    4. set all the information that needs to be set
5. resize the LVM physical volume
6. extend the LVM volume group
7. resize the LVM volume
8. resize the file system



Excellent I have a plan and now we can begin to execute it.
What can possibly go wrong?
 \- make a typo and loose everything on my system.

#### Step 0 - Check partitions

Check to make sure that I know what partition / volume is which so the wrong one does not get deleted.


```bash
$ sudo fdisk -l /dev/nvme0n1
Disk /dev/nvme0n1: 931.51 GiB, 1000204886016 bytes, 1953525168 sectors
...
Device             Start        End    Sectors   Size Type
/dev/nvme0n1p1      2048    1230847    1228800   600M EFI System
/dev/nvme0n1p2 1230847      3327999    2097152     1G Linux filesystem
/dev/nvme0n1p3 3327999    590530559  587202560   280G Linux LVM
/dev/nvme0n1p4 590530559  592627711    2097152     1G Linux filesystem
/dev/nvme0n1p5 592627711  802342911  209715200   100G Linux LVM
/dev/nvme0n1p6 805513216  807610367    2097152     1G Linux filesystem
/dev/nvme0n1p7 807610368 1953525134  587202560   270G Linux LVM
$
$ sudo pvscan
[sudo] password for marshallasch:
  PV /dev/nvme0n1p3   VG other         lvm2 [280 GiB / 120.41 GiB free]
  PV /dev/nvme0n1p5   VG fedora31      lvm2 [100 GiB / 40.41 GiB free]
  PV /dev/nvme0n1p7   VG fedora33      lvm2 [270 GiB / 60 GiB free]
  Total: 3 [650 GiB] / in use: 3 [650 GiB] / in no VG: 0 [0   ]
$
$ sudo lvs
LV   VG       Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  home fedora33 -wi-ao---- 100.00g                                                    
  root fedora33 -wi-ao---- 70.00g  
  home other    -wi-ao---- 110.00g                                                    
  root other    -wi-ao---- 70.00g  
  home fedora31 -wi-ao---- 50.00g                                                    
  root fedora31 -wi-ao---- 50.00g  
$
$ sudo lvscan
ACTIVE            '/dev/fedora33/home' [100.00 GiB] inherit
ACTIVE            '/dev/fedora33/root' [70.00 GiB] inherit
ACTIVE            '/dev/fedora31/home' [50.00 GiB] inherit
ACTIVE            '/dev/fedora31/root' [50.00 GiB] inherit
ACTIVE            '/dev/other/home'    [100.00 GiB] inherit
ACTIVE            '/dev/other/root'    [70.00 GiB] inherit

```

#### Step 2 - delete LVM volumes

Delete the volumes:
```bash
$ sudo lvremove /dev/fedora31/home
Do you really want to remove active logical volume "home"? [y/n]: y
  Logical volume "home" successfully removed
$ sudo lvremove /dev/fedora31/root
$ sudo lvremove /dev/other/home
$ sudo lvremove /dev/other/root
```
Delete the volume groups:

```bash
$ sudo vgremove fedora31
  Volume group "fedora31" successfully removed
$ sudo vgremove other
```

Delete the physical volumes:

```bash
$ sudo pvremove /dev/nvme0n1p5
  Volume group "/dev/nvme0n1p5" successfully removed
$ sudo pvremove /dev/nvme0n1p3
```


#### Step 3 - delete the physical partitions

To do this I chose to use `fdisk` because it is my preferred partition management tool,
but there are other that can do the same thing.

```bash
$ sudo fdisk /dev/nvme0n1
Welcome to fdisk (util-linux 2.36.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help):
```

The first step is to list the partition so we can be sure to delete the correct one by using the `p` command.

```bash
Command (m for help): p
Disk /dev/nvme0n1: 931.51 GiB, 1000204886016 bytes, 1953525168 sectors
Disk model: Samsung SSD 970 EVO 1TB                 
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 3A5CDF53-454D-4C0B-BB84-C4572BC1EC5B

Device             Start        End   Sectors  Size Type
/dev/nvme0n1p1      2048    1230847   1228800  600M EFI System
/dev/nvme0n1p2 1230847      3327999    2097152     1G Linux filesystem
/dev/nvme0n1p3 3327999    590530559  587202560   280G Linux LVM
/dev/nvme0n1p4 590530559  592627711    2097152     1G Linux filesystem
/dev/nvme0n1p5 592627711  802342911  209715200   100G Linux LVM
/dev/nvme0n1p6 805513216  807610367   2097152    1G Linux filesystem
/dev/nvme0n1p7 807610368 1373857791 566247424  270G Linux LVM
```

Now we have confirmed this is the correct drive and we want to delete:
- /dev/nvme0n1p2
- /dev/nvme0n1p3
- /dev/nvme0n1p4
- /dev/nvme0n1p5

Now issue the `d` command in fdisk to delete the partition

```bash
Command (m for help): d
Partition number (1-7, default 7): 2
Command (m for help): d
Partition number (1,3-7, default 7): 3
Command (m for help): d
Partition number (1,4-7, default 7): 4
Command (m for help): d
Partition number (1,5-7, default 7): 5
```

Confirm that the correct partitions are now gone, and that there is free space
in the correct blocks:

```bash
Command (m for help): p
Disk /dev/nvme0n1: 931.51 GiB, 1000204886016 bytes, 1953525168 sectors
Disk model: Samsung SSD 970 EVO 1TB                 
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 3A5CDF53-454D-4C0B-BB84-C4572BC1EC5B

Device             Start        End   Sectors  Size Type
/dev/nvme0n1p1      2048    1230847   1228800  600M EFI System
/dev/nvme0n1p6 805513216  807610367   2097152    1G Linux filesystem
/dev/nvme0n1p7 807610368 1373857791 566247424  270G Linux LVM
Command (m for help): F
Unpartitioned space /dev/nvme0n1: 383.51 GiB, 411792572416 bytes, 804282368 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes

  Start       End   Sectors   Size
1230847    805513216  804282368 383.5G
1373857791 1953525134 804282368 200.5G
```

That looks good, I should have a block of free space between partitions 1 and 6, and after 7.
It looks like we are good to save the changes and quit.

```bash
Command (m for help): w
```

We probably should reload the partition table after we made those changes.

```bash
$ sudo partprobe /dev/nvme0n1
```

#### Step 4 - extend the existing partition

Again we will be using `fdisk` to update the partitions.
The first step is to get all the information we are going to need,
this can be done using the `p` command to view the partition table, and the `i`
command to view more information.


```bash
$ sudo fdisk /dev/nvme0n1
Command (m for help): p
Disk /dev/nvme0n1: 931.51 GiB, 1000204886016 bytes, 1953525168 sectors
Disk model: Samsung SSD 970 EVO 1TB                 
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 3A5CDF53-454D-4C0B-BB84-C4572BC1EC5B

Device             Start        End   Sectors  Size Type
/dev/nvme0n1p1      2048    1230847   1228800  600M EFI System
/dev/nvme0n1p6 805513216  807610367   2097152    1G Linux filesystem
/dev/nvme0n1p7 807610368 1373857791 566247424  270G Linux LVM
Command (m for help): i
Partition number (1,6,7, default 7): 7
Device: /dev/nvme0n1p7
 Start: 807610368
   End: 1373857791
Sectors: 566247424
  Size: 270G
  Type: Linux LVM
Type-UUID: E6D6D379-F507-44C2-A23C-238F2A3DF928
  UUID: B3BE640A-6554-FFFF-9242-084C0EAB9FAA
```

Using `fdisk` partitions cant actually be extended, the only way to do that is to
delete the partition and create a new one that starts at the exact same sector number.

```bash
Command (m for help): d
Partition number (1,6,7, default 7): 7
Command (m for help): n
Partition number (2-5,7-128, default 2): 7
First sector (1230848-1953525134, default 807610368):  807610368
Last sector, +/-sectors or +/-size{K,M,G,T,P} (807610368-1953525134, default 1953525134):

Created a new partition 7 of type 'Linux filesystem' and of size 546.4 GiB.
Partition #7 contains a LVM2_member signature.

Do you want to remove the signature? [Y]es/[N]o: n
```

Note that I made sure that the partition number and the starting sector number was the same, I left the last sector as the default value because I wanted it to fill the rest of the drive.
Also note that the partition type that it set by default is not correct and that needs to be changed

To update the partition we can use the `t` command, to list all the partition types `L` can be used.

```bash
Command (m for help): t
Partition number (1,6,7, default 7): 7
Partition type or alias (type L to list all): LVM
```

Next we have to set the UUID for the partition to be the same as what it was before.
This is important when drives are mounted by their UUIDs instead of by name, ie for fstab.
This can be done by entering advanced mode with command `x`, then `u`.

```bash
Command (m for help): x
Command (m for help): u
Partition number (1,6,7, default 7): 7
New UUID (in 8-4-4-4-12 format): B3BE640A-6554-FFFF-9242-084C0EAB9FAA
Command (m for help): r
```

Now we can save and exit once we confirm that this is correct and reload the partition table.

```bash
Command (m for help): w

$ sudo partprobe /dev/nvme0n1
```

#### Step 5 - resize the LVM physical volume

```bash
$ sudo pvresize /dev/nvme0n1p7
```

#### Step 6 - extend the volume

We can extend the logical volume by different amounts, in this case I am just going to increase it by 50GB.

```bash
$ sudo lvextend -L+50G /dev/mapper/fedora33/root
```

#### Step 7 - extend the filesystem

Because I am using ext4 as my file system, and it supports online resizing, I am able to increase the size while it is mounted.

```bash
$ sudo resize2fs /dev/mapper/fedora33/root
```

Now if we check the size of the file system we should see the new sizes and our out of space issue should be solved right?

```bash
$ df -h
Filesystem                        Size  Used Avail Use% Mounted on
devtmpfs                           16G     0   16G   0% /dev
tmpfs                              16G     0   16G   0% /dev/shm
tmpfs                             6.3G  2.2M  6.3G   1% /run
/dev/mapper/fedora33-root         118G   74G   39G  66% /
tmpfs                              16G   36K   16G   1% /tmp
/dev/nvme0n1p6                    976M  249M  661M  28% /boot
/dev/mapper/fedora33-home         196G   79G  107G  43% /home
/dev/nvme0n1p1                    599M   23M  577M   4% /boot/efi
```


Perfect that looks exactly like what I would expect to see, the sizes are right.
I am supper happy because it worked perfectly, and nothing went horribly wrong, and the computer still functions.
It was easy, _too easy_ one might even say.

And finally a quick sanity check, lets make sure the computer boots back up after a reboot.  


### 🚨🚨🚨 Emergency shell 🚨🚨🚨

![Dracut shell screen shot](/assets/img/dracut-shell.jpg)

And we are back in the emergency shell again 😦, well what did I do wrong this time?

Getting out of the emergency shell can be done by running:

```bash
$ lvm lvchange -a y fedora33/root
$ exit
```

It turns out that after deleting some of the partitions I forgot to update the GRUB configuration,
for some reason my grub configuration in `/etc/default/grub` was set to probe for the unused LVM volumes.
Correcting that and reconfiguring grub was the answer to my problems this time.


```bash
$ sudo vim /etc/default/grub
$ sudo sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

_Now_ things should work as expected.
Rebooting now works, and the computer does indeed turn on when it is told to.

# Useful links

Although I have a fair bit of linux knowledge from messing around with my systems I was not able to figure out
what I did wrong and how to fix it on my own.
These links (along with a couple others that I lost in the mad scramble to get my machine working again) were
the key to getting things working again.

- [https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/logical_volume_manager_administration/index](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/logical_volume_manager_administration/index)
- [https://fedoramagazine.org/initramfs-dracut-and-the-dracut-emergency-shell/](https://fedoramagazine.org/initramfs-dracut-and-the-dracut-emergency-shell/)
- [https://serverfault.com/questions/36038/reread-partition-table-without-rebooting](https://serverfault.com/questions/36038/reread-partition-table-without-rebooting)
- [https://askubuntu.com/questions/24027/how-can-i-resize-an-ext-root-partition-at-runtime](https://askubuntu.com/questions/24027/how-can-i-resize-an-ext-root-partition-at-runtime)



<!-- links -->

[Docker]: https://www.docker.com/
[LVM documentation]: https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/logical_volume_manager_administration/vg_rename
[fedora magazine dracut]: https://fedoramagazine.org/initramfs-dracut-and-the-dracut-emergency-shell/
[simulation code]: https://github.com/marshallAsch/saf
