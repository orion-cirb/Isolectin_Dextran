// Detect dextran (ch 561) outside vessels (ch 635)


requires("1.53");

inDir = getDirectory("Choose images directory");
list = getFileList(inDir);

setBatchMode(true);

// area to search in microns^2
var diam = 70;
var x, y, slices, tracks;



// create output folder
outDir = inDir + "Results"+ File.separator();
if (!File.isDirectory(outDir)) {
	File.makeDirectory(outDir);
}
// create headers for results file
fileResults = File.open(outDir + "results.xls");
print(fileResults,"Image name\tVessels Area\tPourcentage Vessels Area\tDextran area\tPourcentage dextran area\n");

setForegroundColor(0, 0, 0);
setBackgroundColor(255, 255, 255);
run("Set Measurements...", "area area_fraction redirect=None decimal=3");

for (i = 0; i < list.length; i++) {
  	if (endsWith(list[i], ".nd")) {	 
  	  	file = inDir + list[i];
  	  	rootName = File.getNameWithoutExtension(list[i]); 
  	  
  	  	// open vessels isolecin (ch4) and dextran (ch3) channels 
  	  	run("Bio-Formats Importer", "open=["+file+"] autoscale color_mode=Default rois_import=[ROI manager] specify_range split_channels view=Hyperstack stack_order=XYCZT c_begin=3 c_end=4 c_step=1");
  	  	
  	  	// Select vessel image
  	  	vesselImage = rootName+"_w1Single-SPI-405.TIF - C=0";
  	  	selectWindow(vesselImage);
  	  	run("Gaussian Blur...", "sigma=2");
  	  	setAutoThreshold("Huang dark");
  	  	setOption("BlackBackground", false);
		run("Convert to Mask");
		List.setMeasurements;
		vesselsArea =  List.getValue("Area");
		vesselsAreaPour = List.getValue("%Area");
		run("Create Selection");
		// select dextran image
		dextranImage = rootName+"_w1Single-SPI-405.TIF - C=1";
		selectWindow(dextranImage);
		run("Restore Selection");
		run("Fill", "slice");
		run("Select None");
		setAutoThreshold("Otsu dark");
		run("Convert to Mask");
		List.setMeasurements();
		dextranArea = List.getValue("Area");
		dextranAreaPour = List.getValue("%Area");
  	  	print(fileResults, rootName+"\t"+vesselsArea+"\t"+vesselsAreaPour+"\t"+dextranArea+"\t"+dextranAreaPour+"\n");

  	  	// Save results image
  	  	run("Merge Channels...", "c1=[&dextranImage] c2=[&vesselImage] create");
		saveAs("Tiff", outDir+rootName+"_results.tif");
		close();
	}
}
File.close(fileResults);
showStatus("Process done...");   	  	