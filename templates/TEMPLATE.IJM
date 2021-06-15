/*
 * 
 */
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix
//run("Install PlugIn...", "Find_focused_slices.class"); 

{
	Results=newArray();
for (i = 0; i < 6; i++) {
	setResult("Results", i, Results[i]);
	setResult("Totals", i, 0);
}




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
run("Z Project...", "projection=[Min Intensity]"); //sum of slices?? min intensity //Rad52–GFP foci were
//counted by inspecting all focal planes for at least 300 cells
setAutoThreshold("MaxEntropy dark");//max entropy
run("Convert to Mask"); //converts it into an 8 bit image for watershed to run
run("Watershed");
run("Set Measurements...", "min integrated redirect=None decimal=3");
run("Analyze Particles...", "size=30-Infinity show=Outlines display clear add");
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
Table.deleteColumn("Min");
Table.deleteColumn("Max");
Table.deleteColumn("IntDen");
Table.deleteColumn("RawIntDen");

saveAs("Results", output+"/u1982583_"+ title + "_cells.csv"); // how to remove the .tif

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
Zeropercent=round((Zero/TotalNumber)*100);
Onepercent=round((One/TotalNumber)*100);
Twopercent=round((Two/TotalNumber)*100);


totals=newArray(title,TotalNumber,CellsFoci,Zero,Zeropercent,One,Onepercent, Two,Twopercent, Greater);
names=newArray("FileName","Totno.Cells","No.CellswithFoci", "No.Cellswith0foci","%Cellswith0foci","No.Cellswith1foci","%Cellswith1foci","No.Cellswith2foci","%No.Cellswith2foci","No.Cellswith>2foci");

//Table.create(name)

for (i = 0; i < totals.length; i++) {
setResult(Results, i, totals[i]);
}






Array.print(totals); // this gives a rather nice visual display of the ongoing process in a print by print manner for visual monitoring of process.
//I  first used the getInfo("log"); save(output + "/" + file +"_profile.csv"); run("Close"); however i found that not to be robust and replicable enough,
//in high throughput measuring analysis that can often involve an already occupied log window. 
//I moved on to the 

	

	close("*");


selectWindow("Log");


saveAs("Text", output+ "/"+"u1982583_totals.csv");


}

{
	total=getInfo("Log");
	

	names=newArray("FileName","Totno.Cells","No.CellswithFoci", "No.Cellswith0foci","%Cellswith0foci","No.Cellswith1foci","%Cellswith1foci","No.Cellswith2foci","%No.Cellswith2foci","No.Cellswith>2foci");

}
//tif file, cells are merged and dont look good so need to get the z projection on min intensity then max in threshold on the , then change the slider to find a good cell.


