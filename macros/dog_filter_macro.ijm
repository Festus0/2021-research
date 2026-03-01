// The paper discusses the problems with implementing the exact Laplacian of
// Gaussian filter, and suggests that it can be well approximated by a Diference of
//Gaussians (DoG) filter. Write a well annotated ImageJ macro that implements such a
//filter (remember: any built-in ImageJ functions are fair game!) and show the results
//of running that for your real-world images of choice. Compare the results between
//LoG and DoG.
Dialog.create("Choose filter sizes for DoG filtering");//creates a dialog box for picking of sigma values.
Dialog.addNumber("Gaussian sigma 1", 1);//allows the use of user selected values with optimal ratio values discovered after experimentation set as the default
Dialog.addNumber("Gaussian sigma 2", 1.6); //allows the use of user selected values with optimal ratio values discovered set as the default
Dialog.show();// this function pops up the dialog box with above parameters
sigma1 = Dialog.getNumber();//This line of code allows the user to be able to input their own sigma1 value, for expermentation and easy adjustment.
sigma2 = Dialog.getNumber(); //This line of code allows the user to be able to input their own sigma value, for expermentation and easy adjustment.

title=getTitle(); //Enables the user inputted image to be selected and set as the variable title for easy selection in future
selectWindow(title);//selects the window of interest
run("8-bit");//allows enhanced edge detection of the image 
run("Duplicate...", " "); //duplicates the image
duplicate=getTitle();//Enables the user inputted image to be selected and set as the variable duplicate for easy selection in future
selectWindow(duplicate);//duplicates the image
run("8-bit");//allows enhanced edge detection of the image 
run("Gaussian Blur...", "sigma="+sigma1);// first gaussian blur filter
selectWindow(duplicate);//selects the second image for alternative blur at different sigma value.
run("Gaussian Blur...", "sigma="+sigma2);//second gaussian blur filter
imageCalculator("Subtract", duplicate,title); // Image calculator to get the subtracted differences of the Gaussians
run("Enhance Contrast...", "saturated=0.3 normalize"); //contrast enhancing to enable it to give more visual localised edges 

