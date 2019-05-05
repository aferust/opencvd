#ifndef _OPENCV3_ML_H_
#define _OPENCV3_ML_H_

#include <stdbool.h>

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
extern "C" {
#endif

#include "core.h"

#ifdef __cplusplus
typedef cv::Ptr<cv::ml::SVM>* SVM;
typedef cv::Ptr<cv::ml::ParamGrid>* ParamGrid;
/* typedef cv::Ptr<cv::ml::SVM::Kernel>* Kernel; */
#else
typedef void* SVM;
typedef void* ParamGrid;
/* typedef void* Kernel; */
#endif

SVM SVM_Create();
void SVM_Close(SVM svm);
double SVM_GetC(SVM svm);
Mat SVM_GetClassWeights(SVM svm);
double SVM_GetCoef0(SVM svm);
double SVM_GetDecisionFunction(SVM svm, int i, Mat alpha, Mat svidx);
double SVM_GetDegree(SVM svm);
double SVM_GetGamma(SVM svm);
int SVM_GetKernelType(SVM svm);
double SVM_GetNu(SVM svm);
double SVM_GetP(SVM svm);
Mat SVM_GetSupportVectors(SVM svm);
TermCriteria SVM_GetTermCriteria(SVM svm);
int SVM_GetType(SVM svm);
Mat SVM_GetUncompressedSupportVectors(SVM svm);
void SVM_SetC (SVM svm, double val);
void SVM_SetClassWeights(SVM svm, Mat val);
void SVM_SetCoef0 (SVM svm, double val);
// void setCustomKernel (SVM svm, Kernel _kernel);
void SVM_SetDegree (SVM svm, double val);
void SVM_SetGamma (SVM svm, double val);
void SVM_SetKernel (SVM svm, int kernelType);
void SVM_SetNu (SVM svm, double val);
void SVM_SetP (SVM svm, double val);
void SVM_SetTermCriteria(SVM svm, TermCriteria val);
void SVM_SetType(SVM svm, int val);
ParamGrid SVM_GetDefaultGridPtr(int param_id);
bool SVM_TrainAuto0(SVM svm, Mat samples, int layout, Mat responses, int kFold, ParamGrid Cgrid,
    ParamGrid gammaGrid, ParamGrid pGrid, ParamGrid nuGrid, ParamGrid coeffGrid,
    ParamGrid degreeGrid, bool balanced);

ParamGrid ParamGrid_Create (double minVal, double maxVal, double logstep);
double ParamGrid_MinVal (ParamGrid pg);
double ParamGrid_MaxVal (ParamGrid pg);
double ParamGrid_LogStep (ParamGrid pg);

#ifdef __cplusplus
}
#endif

#endif //_OPENCV3_ML_H_
