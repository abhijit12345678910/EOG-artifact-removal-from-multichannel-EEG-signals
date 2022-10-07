This Matlab Toolbox permits to perform the 1D and 2D Empiricals transforms described in the papers:

- J.Gilles, "Empirical wavelet transform" to appear in IEEE Trans. Signal Processing, Vol.61, No.16, 3999--4010, August 2013.
Preprint available at ftp://ftp.math.ucla.edu/pub/camreport/cam13-33.pdf
- J.Gilles, G.Tran, S.Osher "2D Empirical transforms. Wavelets, Ridgelets and Curvelets Revisited", SIAM Journal on Imaging Sciences, Vol.7, No.1, 157--186, January 2014. Preprint available at ftp://ftp.math.ucla.edu/pub/camreport/cam13-35.pdf
- J.Gilles, K. Heal, "A parameterless scale-space approach to find meaningful modes in histograms - Application to image and spectrum segmentation", International Journal of Wavelets, Multiresolution and Information Processing, Vol.12, No.6, 1450044-1--1450044-17, December 2014.
Preprint available at ftp://ftp.math.ucla.edu/pub/camreport/cam14-05.pdf

This toolbox is freely distributed and can be used without any charges for research purposes but I will appreciate if you cite the previous papers ;-)
If you want to use this code for commercial purposes, please contact me before.

For any questions, comments (if you find a bug please send me all information so I can fix it and update the toolbox) must be send to jegilles@math.ucla.edu

If you develop some new functionalities and want them included in this toolbox, just provide me the corresponding files and which credit I must add in this README file.

==========================================================
									    VERSION
==========================================================
- Current version:  4.0 (December 13th, 2019): This is a major revision! The 1D transform can now handle complex signals (i.e the empirical wavelets are themselves complex since they are not necessarily symmetric in the Fourier domain). The construction of the curvelet filters has been revised, simplified in order to guarantee almost perfect reconstruction. All other 2D transforms have been cleaned and simplified when possible. The plotting functions now add some title to each subfigure. In term of organization, almost all functions now contain the acronym 'EWT' in their name (most of the time as a prefix) to avoid any conflict with external functions.
- Previous version: 3.4 (November 20th, 2019): fix a bug in the construction of the 1D wavelet filters (for the last filter in the high frequencies) by adding the function EWT Meyer Wavelet last.m and removal of using the mirroring in the 1D code before performing the filtering. These fixes now permit to get almost perfect reconstruction. Finally a test was added in the EWT TF Plan.m function such that it can manage either horizontal or vertical boundaries vectors.
- Previous version: 3.2 (September 6th, 2016): new faster code to compute the scale-space boundary detection + remove all parfor so the toolbox can be use if you don't have any parallel capabilities.
- Previous version: 3.0 (July 21th, 2015): adding the EWT-Curvelet option 3 (scales detected per angular sector) + fix of image sizes issues + wrong curvelet filters for the last scale.
- Previous version: 2.0 (April 23th, 2014): adding new functions (like scale-space detection, TF plane generation,...) + documentation, the FTC method is removed and no longer available.
- Previous version: 1.2 (June 18th, 2013): bugs fixes
- Previous version: 1.0 (June 10th, 2013): original version

==========================================================
									NEEDED TOOLBOXES
==========================================================

If you want to run all functionalities, you need to have the following Matlab toolboxes properly installed on computer:

- Flandrin's EMD toolbox (needed in the 1D transform to perform the Hilbert transform and visualize the time-frequency plane) 
	available at http://perso.ens-lyon.fr/patrick.flandrin/emd.html
- Elad's Pseudo-Polar FFT toolbox (needed for the 2D transforms except the tensor based transform)
	available at http://www.cs.technion.ac.il/~elad/software/

==========================================================
										INSTALLATION
==========================================================

1- Add the path to all folders to your Matlab configuration (menu Files -> Set Paths)

==========================================================
										ORGANIZATION
==========================================================
This toolbox is organized as follows:

EWT
 |
 |-1D 						: 1D EWT functions
 |-2D						: 2D EWT functions
 |	|-Curvelet 					: Empirical curvelet transform
 |  |-Littlewood-Paley 					: Empirical Littlewood-Paley wavelet transform
 |  |-Ridgelet 						: Empirical Ridgelet transform
 |  |-Tensor 						: Empirical Tensor wavelet transform
 |-Boundaries					: functions used to perform to Fourier supports
 |  |-LocalMaxima					: Functions performing detections based on local maxima and midway or localminima
 |  |-MorphoMath					: Functions performing the Morphological operator to preprocess the spectrum
 |  |-PowerLaw						: Function preprocessing the spectrum by removing its power law approximation
 |  |-ScaleSpace					: Functions to perform the detection based on the scale-space method
 |-Documentation				: Toolbox documentation
 |-Tests
 |	|-1D						: Functions to perform basic tests on several 1D signals
 |	|-2D						: Functions to perform basic tests of the several 2D transforms on different images
 |-Utilities
 |  |-1D						: Useful function to plot results in 1D case (Time-Frequency plane, components, boundaries)
 |  |-2D						: Useful function to plot results in 2D case (different type of components, 2D boundaries,...)

==========================================================
										UTILIZATION
==========================================================
The best way to learn how to use this toolbox is to look at the documentation and play with the files named Test_xxxx 
on the subfolders of the Tests folders.
The provided test scripts are the ones, with new options, used to generate the experiments presented in the two papers.
Some utlities are provided to visualize the transform outputs, the detected Fourier supports, ...
