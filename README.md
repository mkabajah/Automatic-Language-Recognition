# Automatic-Language-Recognition
This project tackles the automatic spoken language recognition by a computer( 12 languages ) . Which implemented in MATLAB, Multiple Algorithm were used: K-Mean, UBM- GMM, SVM, Push-Back GMM, intersession variability compensation, Phonotactics and N-Gram, I-Victor.

This project tackles the automatic spoken language recognition by a computer. From this
perspective an implementation of this kind of system has been done with the objective to
recognize spoken language in telephone speech. The process of Language recognition consists
of 2 modules mainly: - feature extraction and feature matching. Feature extraction is the
process in which we extract a small amount of data from the voice signal that can later be used
to represent each Language. Feature matching involves identification of the unknown
language speech by comparing the extracted features from speech input with the ones from a
set of known languages model, Cepstral Coefficient Calculation and Mel frequency Cepstral
Coefficients (MFCC)[see 3.1] are applied for feature extraction purpose. K-Mean, UBMGMM
(Universal Background Model based Gaussian Mixture Modeling), SVM (Support
Victor Machine), Push-Back SVM to GMM, intersession variability compensation,
Phonotactics and N-Gram, Gaussian Tokenization and Fused system algorithms are used for
generating template and feature modeling, reduction, matching purpose.
An implementation was done and gave acceptable results (above 96% of accuracy) on the
1149 different utterance from the twelve languages of call-friend carpus data set

for extra information i attached my report on this program 
