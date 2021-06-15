
//Write a well annotated ImageJ macro that implements the Laplacian of Gaussian
//filter as described by either equation 1.1 or equations 1.2-1.4. For a real-world image
//of your choice (photograph, microscopy image...) demonstrate how you can use
//your macro to extract particular features by choosing particular values of σ. You can
//use the code available as “calculate_kernel.ijm” to generate the LoG kernel in ImageJ
//macro language – note that the function “lapofgauss” needs to be implemented by
//you using the formulas from the paper!

/* 
 *  Macro to calculate kernel and implement Laplacian of Gaussian
 */

// LAPLACIAN OF GAUSSIAN FUNCTION
Dialog.create("Choose filter sizes for DoG filtering"); //creates a dialog box for picking of sigma values.
Dialog.addNumber("LoG sigma", 0.6); //allows the use of user selected values with optimal ratio values discovered after experimentation set as the default
Dialog.show(); // this function pops up the dialog box with above parameters
sigma = Dialog.getNumber(); //This line of code allows the user to be able to input their own sigma value, for expermentation and easy adjustment.
//LoG function as per Eq 1.1
function lapofgauss(x, y, sigma){
    factor = -1*(1/((2*PI*pow(sigma,4))))*(2-((pow(x,2)+pow(y,2))/(pow(sigma,2))))* exp(-1.0 * (pow(x, 2) + pow(y, 2)) / (2 * pow(sigma, 2)));
    return factor;
}
// I created the function based on the provided equation 1.1 with input x,y and sigma as shown in the equation:
// In handsight and discussed in the write up, it was probably easier to generate the equation by having 3 factors:
// this would break up the eaquation into 3 easy to code, adjust and troubleshoot parts that would speed up the coding and 
// enable easier following of the function.
// This function called lapofgauss takes x,y and sigma as input and with that generates a factor with the coded eqaution and 
//finally returns it for use below:

//CALCULATE KERNEL FUNCTION

function calculate_kernel(sigma){   //this function takes sigma as an input, this determines the degradation of the LoG function 
	kernel_size = 15;                // The kernel size is adjustable (default=15) as seen in write up and comparison with the DoG.
	centre = floor(kernel_size/2);    // 
	kernel = "[";                     //The rest of this code involves taking values of x and y co-ordinates and generating a kernel by applying the LoG function to it
	min_val = 1;                      //
	kernel_num=newArray(kernel_size * kernel_size);   //
	for (i=0;i<kernel_size;i++){ 						//This for loop goes through each value of lenght and width in a 15*15 kernel and applies LoG function to it 
		for (j=0;j<kernel_size;j++){						//
			val = lapofgauss(i-centre,j-centre,sigma);			//
			kernel_num[i*kernel_size+j] = val;					//
																
		}
	}
	for (i=0;i<kernel_size;i++){								//
		for (j=0;j<kernel_size;j++){								//
			kernel = kernel + " " + d2s(kernel_num[i*kernel_size+j],7);		//
		}
		kernel = kernel + "\n";												//
	}
	kernel = kernel + "]";													//
	return kernel;															//
	
}


kernel=calculate_kernel(sigma); //This allows the input and calculation of a kernel with degradation constant of sigma, discussed oin write up
	

run("Convolve...", "text1="+kernel +"normalize");							//function to convolve the image
run("32-bit");      // Convert to 32-bit (so we can have negative values) and so maximise the power of our filter
run("Enhance Contrast...", "saturated=0.3 normalize"); //change the contrast and so imporove the edge detection
run("Enhance Contrast", "saturated=0.35");
//run("Brightness/Contrast...");   //change the brightness and so imporove the edge detection
print(kernel);				// Useful diagnostic to enable the the visual display of the working function and enable adjustment
