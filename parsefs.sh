#!/bin/sh

#  parsefs.sh
#  
#
#  Created by asalpy on 28.12.15.
#

import os, sys
import binascii
import datetime

def invert(hexstr):
    listval = list(hexstr)
    order = [6, 7, 4, 5, 2, 3, 0, 1]
    listval = [listval[i] for i in order]
    hexval = ''.join(listval)
    return int(hexval,16)

def invert16(hexstr):
    listval = list(hexstr)
    order = [2, 3, 0, 1]
    listval = [listval[i] for i in order]
    hexval = ''.join(listval)
    return int(hexval,16)

timeconst = (((1970 - 1904)*365 + 17)*24 + 3)*60*60

volumefile = file("/dev/disk6s5","rb")
volumefile.seek(1024)
signature = volumefile.read(2)
print ("Signature " + signature)
if (binascii.hexlify(signature) == '482b'):
    print ("HFS Plus Volume signature")
version = volumefile.read(2)
print ("Version " + binascii.hexlify(version))
if (binascii.hexlify(version) == '0004'):
    print ("HFS Plus Volume version")
attr = volumefile.read(4)
print ("Attributes " + binascii.hexlify(attr))

intattr = int(binascii.hexlify(attr),16)
k = intattr & (1 << 7)
if k > 0:
    print ("kHFSVolumeHardwareLockBit")
k = intattr & (1 << 8)
if k > 0:
    print ("kHFSVolumeUnmountedBit")
k = intattr & (1 << 9)
if k > 0:
    print ("kHFSVolumeSparedBlocksBit")
k = intattr & (1 << 10)
if k > 0:
    print ("kHFSVolumeNoCacheRequiredBit")
k = intattr & (1 << 11)
if k > 0:
    print ("kHFSBootVolumeInconsistentBit")
k = intattr & (1 << 12)
if k > 0:
    print ("kHFSCatalogNodeIDsReusedBit")
k = intattr & (1 << 13)
if k > 0:
    print ("kHFSVolumeJournaledBit")
k = intattr & (1 << 15)
if k > 0:
    print ("kHFSVolumeSoftwareLockBit")

mountver = volumefile.read(4)

print ("Last mounted version " + mountver)
if (binascii.hexlify(mountver) == '4846534a'):
    print ("Journaled volume")
journalinfoblock = binascii.hexlify(volumefile.read(4))
addr = int(journalinfoblock,16)
print ("Journal info block " + hex(addr))
createDate = int(binascii.hexlify(volumefile.read(4)),16) - timeconst
print ("Create date ") # + str(createDate))

date = datetime.datetime.fromtimestamp(createDate)
print(date)
#td = datetime.date.today()
#print(td)
#print(str(int(td.strftime('%s'))))

modifyDate = int(binascii.hexlify(volumefile.read(4)),16) - timeconst
print ("Modify date ") # + str(modifyDate))

date = datetime.datetime.fromtimestamp(modifyDate)
print(date)

backupDate = int(binascii.hexlify(volumefile.read(4)),16) - timeconst
print ("Backup date ") # + str(backupDate))

date = datetime.datetime.fromtimestamp(backupDate)
print(date)

checkedDate = int(binascii.hexlify(volumefile.read(4)),16) - timeconst
print ("Checked date ") # + str(checkDate))

date = datetime.datetime.fromtimestamp(checkedDate)
print(date)

fileCount = int(binascii.hexlify(volumefile.read(4)),16)
print ("Number of files " + str(fileCount))
folderCount = int(binascii.hexlify(volumefile.read(4)),16)
print ("Number of folders " + str(folderCount))
print ("Block size " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Total blocks " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Free blocks " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Next allocation " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("RSRC clump size " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Data clump size " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Next catalog ID " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Write count " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Encodings bitmap " + binascii.hexlify(volumefile.read(8)))
print ("Finder info")

print ("Directory ID of the directory containing the bootable system " + str(int(binascii.hexlify(volumefile.read(4)),16)))

print ("Parent directory ID of the startup application " + str(int(binascii.hexlify(volumefile.read(4)),16)))

print ("Directory ID of a directory whose window should be displayed in the Finder when the volume is mounted " + str(int(binascii.hexlify(volumefile.read(4)),16)))

print ("Directory ID of a bootable Mac OS 8 or 9 System Folder " + str(int(binascii.hexlify(volumefile.read(4)),16)))

print ("Reserved " + str(int(binascii.hexlify(volumefile.read(4)),16)))

print ("Directory ID of the directory containing the bootable system " + str(int(binascii.hexlify(volumefile.read(4)),16)))

print ("64-bit unique volume identifier " + binascii.hexlify(volumefile.read(8)))

print ("Allocation file logical size " + str(int(binascii.hexlify(volumefile.read(8)),16)))
print ("Clump size " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Total blocks " + str(int(binascii.hexlify(volumefile.read(4)),16)))

for i in range(0,8):
    startblock = int(binascii.hexlify(volumefile.read(4)),16)
    blockcount = int(binascii.hexlify(volumefile.read(4)),16)
    if (startblock > 0) & (blockcount > 0):
        print ("Allocation file start block " + str(startblock))
        print ("Allocation file block count " + str(blockcount))

print ("Extents file logical size " + str(int(binascii.hexlify(volumefile.read(8)),16)))
print ("Clump size " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Total blocks " + str(int(binascii.hexlify(volumefile.read(4)),16)))

for i in range(0,8):
    startblock = int(binascii.hexlify(volumefile.read(4)),16)
    blockcount = int(binascii.hexlify(volumefile.read(4)),16)
    if (startblock > 0) & (blockcount > 0):
        print ("Extents start block " + str(startblock))
        print ("Extents block count " + str(blockcount))

print ("Catalog file logical size " + str(int(binascii.hexlify(volumefile.read(8)),16)))
print ("Clump size " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Total blocks " + str(int(binascii.hexlify(volumefile.read(4)),16)))

catalogstartaddr = 0

for i in range(0,8):
    startblock = int(binascii.hexlify(volumefile.read(4)),16)
    if i == 0:
        catalogstartaddr = startblock * 4096
    blockcount = int(binascii.hexlify(volumefile.read(4)),16)
    if (startblock > 0) & (blockcount > 0):
        print ("Catalog file start block " + str(startblock))
        print ("Catalog file block count " + str(blockcount))

print ("Attribute file logical size " + str(int(binascii.hexlify(volumefile.read(8)),16)))
print ("Clump size " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Total blocks " + str(int(binascii.hexlify(volumefile.read(4)),16)))

for i in range(0,8):
    startblock = int(binascii.hexlify(volumefile.read(4)),16)
    blockcount = int(binascii.hexlify(volumefile.read(4)),16)
    if (startblock > 0) & (blockcount > 0):
        print ("Attribute file start block " + str(startblock))
        print ("Attribute file block count " + str(blockcount))

print ("Startup file logical size " + str(int(binascii.hexlify(volumefile.read(8)),16)))
print ("Clump size " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Total blocks " + str(int(binascii.hexlify(volumefile.read(4)),16)))

for i in range(0,8):
    startblock = int(binascii.hexlify(volumefile.read(4)),16)
    blockcount = int(binascii.hexlify(volumefile.read(4)),16)
    if (startblock > 0) & (blockcount > 0):
        print ("Startup file start block " + str(startblock))
        print ("Startup file block count " + str(blockcount))

print ("Catalog file start address " + str(catalogstartaddr))

volumefile.seek(catalogstartaddr)

print ("Flink " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Blink " + str(int(binascii.hexlify(volumefile.read(4)),16)))
kind = binascii.hexlify(volumefile.read(1))
print ("Kind " + str(int(kind,16)))
intkind = int(kind,16)
if intkind == -1:
    print ("kBTLeafNode")
if intkind == 0:
    print ("kBTIndexNode")
if intkind == 1:
    print ("kBTHeaderNode")
if intkind == 2:
    print ("kBTMapNode")
print ("Height " + str(int(binascii.hexlify(volumefile.read(1)),16)))
numRecords = binascii.hexlify(volumefile.read(2))
print ("Number of records " + str(int(numRecords,16)))
print ("Reserved " + binascii.hexlify(volumefile.read(2)))

print ("Current depth of B-Tree " + str(int(binascii.hexlify(volumefile.read(2)),16)))
print ("The node number of the root node " + hex(int(binascii.hexlify(volumefile.read(4)),16)))
print ("The total number of records contained in all of the leaf nodes " + hex(int(binascii.hexlify(volumefile.read(4)),16)))
print ("The node number of the first leaf node " + hex(int(binascii.hexlify(volumefile.read(4)),16)))
print ("The node number of the last leaf node " + hex(int(binascii.hexlify(volumefile.read(4)),16)))
print ("The size in bytes of a node " + str(int(binascii.hexlify(volumefile.read(2)),16)))
print ("The maximum length of a key in an index or leaf node " + str(int(binascii.hexlify(volumefile.read(2)),16)))
print ("The total number of nodes (be they free or used) in the B-tree " + hex(int(binascii.hexlify(volumefile.read(4)),16)))
print ("The number of unused nodes in the B-tree " + hex(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Reserved1 " + binascii.hexlify(volumefile.read(2)))
print ("Clump size " + hex(int(binascii.hexlify(volumefile.read(4)),16)))

btreetype = binascii.hexlify(volumefile.read(1))
print ("B-Tree type " + str(int(btreetype,16)))
intbtreetype = int(btreetype,16)
if intbtreetype == 0:
    print ("kHFSBTreeType")
if intbtreetype == 128:
    print ("kUserBTreeType")
if intbtreetype == 255:
    print ("kReservedBTreeType")

keycomparetype = binascii.hexlify(volumefile.read(1))
print ("Key compare type (ordering of the keys) " + keycomparetype)
if keycomparetype == 'cf':
    print ("Case folding (case-insensitive)")
if keycomparetype == 'bc':
    print ("Binary compare (case-sensitive)")

attr = binascii.hexlify(volumefile.read(4))

print ("Attributes 0x" + attr)

intattr = int(binascii.hexlify(attr),16)
k = intattr & (1 << 0)
if k > 0:
    print ("B-tree was not closed properly and should be checked for consistency")
k = intattr & (1 << 1)
if k > 0:
    print ("keyLength field of the keys in index and leaf nodes is UInt16")
else:
    print ("keyLength field of the keys in index and leaf nodes is UInt8")
k = intattr & (1 << 2)
if k > 0:
    print ("The keys in index nodes occupy the number of bytes indicated by their keyLength field. HFS Plus Catalog B-tree")
else:
    print ("The keys in index nodes always occupy maxKeyLength bytes. HFS Plus Extents B-tree")

print ("Reserved3 " + binascii.hexlify(volumefile.read(64)))

print ("User data record (reserved) " + binascii.hexlify(volumefile.read(128)))

volumefile.seek(catalogstartaddr + 8192)

print ("Flink " + str(int(binascii.hexlify(volumefile.read(4)),16)))
print ("Blink " + str(int(binascii.hexlify(volumefile.read(4)),16)))
kind = binascii.hexlify(volumefile.read(1))
print ("Kind " + str(int(kind,16)))
intkind = int(kind,16)
if intkind == -1:
    print ("kBTLeafNode")
if intkind == 0:
    print ("kBTIndexNode")
if intkind == 1:
    print ("kBTHeaderNode")
if intkind == 2:
    print ("kBTMapNode")
print ("Height " + str(int(binascii.hexlify(volumefile.read(1)),16)))
numRecords = binascii.hexlify(volumefile.read(2))
print ("Number of records " + str(int(numRecords,16)))
print ("Reserved " + binascii.hexlify(volumefile.read(2)))

print ("Key length " + str(int(binascii.hexlify(volumefile.read(2)),16)))
print ("Parent ID " + str(int(binascii.hexlify(volumefile.read(4)),16)))
namelen = int(binascii.hexlify(volumefile.read(2)),16)
print ("Name length " + str(namelen))
print ("Name " + volumefile.read(namelen))

#print ("Record type " + str(int(binascii.hexlify(volumefile.read(2)),16)))
#print ("Flags " + str(binascii.hexlify(volumefile.read(2))))
#volumefile.read(4)
#print ("File ID " + str(int(binascii.hexlify(volumefile.read(4)),16)))
#
#print ("Type")
#type = int(binascii.hexlify(volumefile.read(2)),16)
#if type == int("0x0001",16):
#    print ("kHFSFolderRecord")
#if type == int("0x0002",16):
#    print ("kHFSFileRecord")
#if type == int("0x0003",16):
#    print ("kHFSFolderThreadRecord")
#if type == int("0x0004",16):
#    print ("kHFSFileThreadRecord")
#
#print ("Flags " + str(binascii.hexlify(volumefile.read(2))))
#print ("Valence " + str(int(binascii.hexlify(volumefile.read(4)),16)))
#print ("Folder ID " + str(int(binascii.hexlify(volumefile.read(4)),16)))
#
#createDate = int(binascii.hexlify(volumefile.read(4)),16) - timeconst
#print ("Create date ") # + str(createDate))
#
#date = datetime.datetime.fromtimestamp(createDate)
#print(date)
##td = datetime.date.today()
##print(td)
##print(str(int(td.strftime('%s'))))
#
#modifyDate = int(binascii.hexlify(volumefile.read(4)),16) - timeconst
#print ("Content modify date ") # + str(modifyDate))
#
#date = datetime.datetime.fromtimestamp(modifyDate)
#print(date)
#
#backupDate = int(binascii.hexlify(volumefile.read(4)),16) - timeconst
#print ("Attributes modify date ") # + str(backupDate))
#
#date = datetime.datetime.fromtimestamp(backupDate)
#print(date)
#
#checkedDate = int(binascii.hexlify(volumefile.read(4)),16) - timeconst
#print ("Access date ") # + str(checkDate))
#
#date = datetime.datetime.fromtimestamp(checkedDate)
#print(date)
#
#checkedDate = int(binascii.hexlify(volumefile.read(4)),16) - timeconst
#print ("Backup date ") # + str(checkDate))
#
#date = datetime.datetime.fromtimestamp(checkedDate)
#print(date)
#
#print ("Owner ID " + str(int(binascii.hexlify(volumefile.read(4)),16)))
#print ("Group ID " + str(int(binascii.hexlify(volumefile.read(4)),16)))
#print ("Admin flags " + str(int(binascii.hexlify(volumefile.read(1)),16)))
#print ("Owner flags " + str(int(binascii.hexlify(volumefile.read(1)),16)))
#print ("File mode " + str(int(binascii.hexlify(volumefile.read(2)),16)))

#print ("Data \n" + str(binascii.hexlify(volumefile.read(8))))

close(volumefile)
