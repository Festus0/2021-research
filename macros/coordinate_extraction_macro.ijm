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
run("Analyze Particles...", "size=10-Infinity show=Outlines display clear add");
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


