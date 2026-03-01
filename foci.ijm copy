// This paper relies heavily on counting foci inside cells, and calculating percentages
//of cells containing foci. Write a well annotated ImageJ macro that follows the specifications
//given below. Test it on the microscopy images available from moodle.
//The microscopy images contain three channels: in the first, you have a cytoplasmic marker,
//on the second a brighfield image of the cells, and on the third a GFP-tagged protein of
//interest. From that information, you must be able to identfy cell boundaries, detect the
//relevant foci on the GFP channel and assign those foci to specific cells.
//Macro Specifications
//Inputs: a directory containing microscopy images and the channel number containing the
//foci of interest. By default (i.e. in the test images), the channel number is 3, but the user
//should be allowed to change it. Afer receiving these inputs, the macro should run without
//any human input being necessary.
//Outputs:
//For each individual image:
//1) A CSV file containing (X,Y) coordinates for each of the detected foci; name it
//YourStudentID_ImageName_foci.csv
//2) A CSV file containing the number of foci detected for each segmented cell; name it
//YourStudentID_ImageName_cells.csv
//3) A .tif file with the outlines of segmented cells; name it
//YourStudentID_ImageName_outlines.tif
//For the whole folder:
//1) A CSV file containing the total number of cells detected, the number of cells with
//foci, a breakdown of how many cells contain 0, 1 and 2 foci, the percentage of cells
//with 0, 1 and 2 foci; name it YourStudentID_totals.csv
//2) A CSV file with the same data as item 1), but with one column per image; name it
//YourStudentID_breakdown.csv

//You will notice the input files are z-stacks where many of the z-slices are out of focus. There
//are two options to deal with this problem: using projections or choosing a single in-focus
//slice. Both have advantages and drawbacks; it’s up to you to pick a solution (remember to
//justify it!). Z-projections are fairly straightorward. However, if you choose to pick an in-focus
//slice you should ideally detect which slice is in focus automatcally inside the macro (an easy
//way to do that is calculating the standard deviation of the whole slice; the maximum
//standard deviation is normally on focus). If you cannot achieve that, you should generate a
//new set of images containing only the slice in focus from each z-stack, and use those as input
//for the macro.
//Templates > ImageJ 1.x > Batch > Process Folder (IJ1 macro)]
/*
 * 
 */
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix
//
processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file){
	open(input+"/"+file);
title = getTitle();
selectWindow(title);
run("Duplicate...", "duplicate channels=1");
ch1=getTitle();
selectWindow(title);
run("Duplicate...", "duplicate channels=3");
ch3=getTitle();
selectWindow(ch1);
run("Z Project...", "projection=[Min Intensity]"); //sum of slices?? min intensity
setAutoThreshold("MaxEntropy dark");//change to max entropy
run("Convert to Mask");
run("Watershed");
run("Set Measurements...", "min integrated redirect=None decimal=3");
run("Analyze Particles...", "size=50-Infinity show=Outlines display clear add");
saveAs("Tiff", output+"/u1982583_"+File.nameWithoutExtension+"_outline.tiff");
selectWindow(ch3);
run("Z Project...", "projection=[Max Intensity]");//stdev??

run("Find Maxima...", "prominence=80 output=List");
saveAs("Results", output+"/u1982583_"+File.nameWithoutExtension+"_foci.csv");
run("Find Maxima...", "prominence=80 output=[Single Points]");
roiManager("Show None");
roiManager("Show All");
selectWindow("Results");
run("Close");
roiManager("Measure");
close("*");
selectWindow("Results");
//centroid then find maxima?? put as a list: xy cordinates

for( i= 1; i < nResults; i++){

	x = getResult("RawIntDen",i);
	y = x/255;
    setResult("Foci Number", i, y);
}

saveAs("Results", output+"/u1982583_"+File.nameWithoutExtension + "_cells.csv");

selectWindow("Results");
TotalNumber= nResults;
CellsFoci=0;
Zero=0;
One=0;
Two=0;
Greater=0;
for(i=1;i<nResults; i++){
	if(getResult("Foci Number",i)==0){
		Zero=Zero+1;
	}
	if(getResult("Foci Number",i)==1){
		One=One+1;
	}
	if(getResult("Foci Number",i)==2){
		Two=Two+1;
	}
	if(getResult("Foci Number",i)>2){
		Greater=Greater+1;
	}
	if(getResult("Foci Number",i)>0){
		CellsFoci=CellsFoci+1;
	}
}
Zeropercent=(Zero/TotalNumber)*100;
Onepercent=(One/TotalNumber)*100;
Twopercent=(Two/TotalNumber)*100;
totals=newArray(TotalNumber,CellsFoci,Zero,Zeropercent,One,Onepercent, Two,Twopercent, Greater);

Array.print(totals);
run("Clear Results");
close("Results");
	close("*");
	
}

getInfo("log");
	save(output + "/" + file +"_profile.txt");
	run("Close");
//tif file, cells are merged and dont look good so need to get the z projection on min intensity then max in threshold on the , then change the slider to find a good cell.


