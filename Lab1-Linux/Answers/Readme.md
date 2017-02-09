# Lab 1 

1. *What is the ``grep`` command?*   
    **A:** it's a command used to print the lines of a file that match a given text or pattern. <br><br> 

2. *What does the ``-prune`` option of ``find`` do? Give an example*  
    **A:** the ``-prune`` option prevents ``find`` from recursing into subdirectories that match the search. For example, to simulate the ``ls`` command, one could do ``find . ! -name . -prune``. This searches the current directory (.) for any file other than the current directory (``! -name .``) and ``-prune`` prevents going into the subddirectories. <br><br>
            
3. *What does the ``cut`` command do?*  
    **A:** it removes sections of each line of a file or files. <br><br>
    
4. *What does the ``rsync`` command do?*  
    **A:** it allows to copy files on a local computer or to/from a remote server (it's a better alternative to ``scp``). <br><br>
   
5. *What does the ``diff`` command do?*  
    **A:** it prints the lines that are different in two files (it also gives "instructions" on how to make them identical). <br><br>
    
6. *What does the ``tail`` command do?*  
    **A:** it prints the last 10 lines of files (one can also select how many lines to print with the ``-n`` option). <br><br>
   
7. *What does the ``tail -f`` command do?*  
    **A:** as the file grows, the appended data is printed. <br><br>
    
8. *What does the ``link`` command do?*  
    **A:** it creates a link to a file. Both the existing file and the link will point to the same data on the disk, so modifying one implies modifying the other. <br><br>

9. *What is the meaning of ``#!/bin/bash`` at the start of scripts?*  
    **A:** it's called a "shebang". It tells the shell what kind of interpreter to run (the route to the interpreter is given after the ``#!`` characters). In this case, the script is to be interpreted by the bash shell. <br><br>
    
10. *How many users exist in the course server?*  
    **A:** there are 6 users with valid shell access (diegoangulo, ingcg, jcleon, lapardo, pa.arbelaez, rv.andres10, sagarzazu, valero, vision). These users are found in the file /etc/passwd (note that, in total, there are 39 users but only 6 have valid shells). <br><br>
        
11. *What command will produce a table of Users and Shells sorted by shell (tip: using ``cut`` and ``sort``)*  
    **A:** the command that does this is ``getent passwd | cut -d ':'  -f 1,7 --output ' '  | sort -k 2 | column -t``. The idea is the following: ``getent passwd`` accesses the /etc/passwd file. ``cut`` "cuts out" each line and uses the delimiter ``:`` to extract the 1st and 7th field (user and shell route). The option ``--output ' '`` separates the users and the shell routes with a space. ``sort -k 2`` sorts each line according to the second field (the shell). Finally, ``column -t`` alligns the results in a 2 column table. <br><br>
   
12. *Create a script for finding duplicate images based on their content (tip: hash or checksum*.
    You may look in the internet for ideas, Do not forget to include the source of any code you use).  
    **A:**  The code used to find the duplicate images based on their content is:
    ```
    find Pictures/  -type f -exec md5sum '{}' ';' | sort | uniq --all-repeated=separate -w 15 > dupes.txt
    ```
    The code was obtained from https://www.linux.com/learn/how-sort-and-remove-duplicate-photos-linux on an article written by Carla Schroder. First we use the command find to get all the files (-f used to find just the files and not directories) in the folder Pictures. With the result obtained we execute the command (-exec) md5sum which generates a unique 128 bit code depending on the content of the file, this allows us to find the repeated content and not the repeated name. The md5sum command repeats for all the files discovered for the find command and generates a hash which will be the input to sort. The sort command will simply rearrange the content numerically and alphabetically. Last the command uniq will filter out the repeated lines and they will be saved in a text file located in the home directory.
<br><br>

13. *Download the *bsds500* image segmentation database and decompress it (keep it in you hard drive, we will come back over this data in a few weeks).*  
    **A:** Check. <br><br>
 
14. *What is the disk size of the uncompressed dataset, How many images are in the directory 'BSR/BSDS500/data/images'?*  
    **A:** ``du -sh BSR`` shows that the disk size of the uncompressed dataset is 244 MB.  
    To count the images we use ``find`` and ``wc`` in the following way: ``find BSR/BSDS500/data/images/ -name "*.jpg" | wc -l``. Explanation: we include only jpg images in the search (``-name *.jpg``) inside the directory, we redirect (``|``) ``find`` output to ``wc``. We use ``-l`` to count just newlines. The result shows that there are 500 images in the directory. <br><br>
   
15. *What is their resolution, what is their format?*  
    **A:** the command ``identify`` (part of the ImageMagick suite of tools) gives us this information (for example, ``identify 8049.jpg``). The pictures' resolution is 481x321 or 321x481 pixels and they are JPEG, 8-bit sRGB images.<br><br>

16. *How many of them are in *landscape* orientation (opposed to *portrait*)?*  
    **A:** There are 348 landscape pictures. To count them, we wrote the following script:  
    ```
    #!/bin/bash
    #Script to count landscape and portrait pictures 
    
    landscape=0
    for im in ./BSR/BSDS500/data/images/**/*.jpg
    do 
        is_lands=$(identify -format '%[fx:(h<w)]' "$im")
        if [[ is_lands -eq 1 ]]
        then
            ((landscape++))
        fi
    done
    echo "There are" $landscape "landscape pictures."
    ```
    
    The script loops through each folder and looks if the image is in landscape orientation by comparing the  horizontal (``h``) and vertical (``v``) values. We use the ``identify`` command to llok at the image's format. If the image's width is greater than its height (``h<w``), then the image is in landscape orientation and we augment the counter. The idea for this script was taken from http://unix.stackexchange.com/questions/294341/shell-script-to-separate-and-move-landscape-and-portrait-images/294408.

 
17. *Crop all images to make them square (256x256).*  
    **A:** The imagemagick documentation gives an exaple of how to crop an image to the desired size. The code is the following:
    ```
    convert Desired.tiff      -resize 64x64^ \
          -gravity center -extent 64x64  cropped.tiff
    ```
    The command will first resize the image to 256x256 to the smallest fitting dimension leaving an overflow. Then we will crop the image on the center. Now we have to do this to all the files in the folder. We can use the command mogrify to apply changes to all the files. We have to be careful using this command because it replaces the images, there are two ways to avoid this. The first is to change the output format and the second to set a different output path. The code using mogrify will be:
     ```
    mogrify -format tiff     \
        -resize 64x64^           \
        -gravity center -extent 64x64 *.tiff
     ```
