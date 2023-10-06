// DETECT VESSELS AND EXTRAVASATED DEXTRAN
// @authors ORION-CIRB

requires("1.53");

// Get images list
inDir = getDirectory("Choose images directory");
list = getFileList(inDir);

setBatchMode(true);

// Create output folder
outDir = inDir + "Results"+ File.separator();
if (!File.isDirectory(outDir)) {
	File.makeDirectory(outDir);
}

// Write headers in results file
fileResults = File.open(outDir + "results.xls");
print(fileResults,"Image name\tVessels area\tVessels area percentage\tDextran area\tDextran area percentage\n");

setForegroundColor(0, 0, 0);
setBackgroundColor(255, 255, 255);
run("Set Measurements...", "area area_fraction redirect=None decimal=3");

for (i = 0; i < list.length; i++) {
  	if (endsWith(list[i], ".nd")) {	 
  	  	file = inDir + list[i];
  	  	rootName = File.getNameWithoutExtension(list[i]); 
  	  
  	  	// Open dextran and vessels channels (channel 3 and 4 respectively)
  	  	run("Bio-Formats Importer", "open=["+file+"] autoscale color_mode=Default rois_import=[ROI manager] specify_range split_channels view=Hyperstack stack_order=XYCZT c_begin=3 c_end=4 c_step=1");
  	  	
  	  	// Select vessels channel
  	  	vesselImage = rootName+"_w1Single-SPI-405.TIF - C=0";
  	  	selectWindow(vesselImage);
  	  	run("Gaussian Blur...", "sigma=2");
  	  	setAutoThreshold("Huang dark");
  	  	setOption("BlackBackground", false);
		run("Convert to Mask");
		List.setMeasurements();
		vesselsArea =  List.getValue("Area");
		vesselsAreaPercentage = List.getValue("%Area");
		run("Create Selection");

		// Select dextran channel
		dextranImage = rootName+"_w1Single-SPI-405.TIF - C=1";
		selectWindow(dextranImage);
		run("Restore Selection");
		run("Fill", "slice");
		run("Select None");
		setAutoThreshold("Otsu dark");
		run("Convert to Mask");
		List.setMeasurements();
		dextranArea = List.getValue("Area");
		dextranAreaPercentage = List.getValue("%Area");
  	  	print(fileResults, rootName+"\t"+vesselsArea+"\t"+vesselsAreaPercentage+"\t"+dextranArea+"\t"+dextranAreaPercentage+"\n");

  	  	// Save results image
  	  	run("Merge Channels...", "c1=[&dextranImage] c2=[&vesselImage] create");
		saveAs("Tiff", outDir+rootName+"_results.tif");
		close();
	}
}

File.close(fileResults);
setBatchMode(false);
showStatus("Analysis done!");
