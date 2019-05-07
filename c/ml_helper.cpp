#include "ml_helper.h"

SVM SVM_Create(){
    return new cv::Ptr<cv::ml::SVM>(cv::ml::SVM::create());
}

void SVM_Close(SVM svm){
    delete svm;
}

double SVM_GetC(SVM svm){
    return (*svm)->getC();
}

Mat SVM_GetClassWeights(SVM svm){
    return new cv::Mat( (*svm)->getClassWeights() );
}
double SVM_GetCoef0 (SVM svm){
    return (*svm)->getCoef0();
}

double SVM_GetDecisionFunction(SVM svm, int i, Mat alpha, Mat svidx){
    return (*svm)->getDecisionFunction(i, *alpha, *svidx);
}

double SVM_GetDegree(SVM svm){
    return (*svm)->getDegree();
}

double SVM_GetGamma(SVM svm){
    return (*svm)->getGamma();
}

int SVM_GetKernelType(SVM svm){
    return (*svm)->getKernelType();
}

double SVM_GetNu(SVM svm){
    return (*svm)->getNu();
}

double SVM_GetP(SVM svm){
    return (*svm)->getP();
}

Mat SVM_GetSupportVectors(SVM svm){
    return new cv::Mat( (*svm)->getSupportVectors() );
}

TermCriteria SVM_GetTermCriteria(SVM svm){
    return new cv::TermCriteria( (*svm)->getTermCriteria() );
}

int SVM_GetType(SVM svm){
    return (*svm)->getType();
}

Mat SVM_GetUncompressedSupportVectors(SVM svm){
    return new cv::Mat( (*svm)->getUncompressedSupportVectors() );
}

void SVM_SetC (SVM svm, double val){
    (*svm)->setC(val);
}

void SVM_SetClassWeights(SVM svm, Mat val){
    (*svm)->setClassWeights(*val);
}

void SVM_SetCoef0 (SVM svm, double val){
    (*svm)->setCoef0(val);
}

// void setCustomKernel (SVM svm, Kernel _kernel);

void SVM_SetDegree (SVM svm, double val){
    (*svm)->setDegree(val);
}

void SVM_SetGamma (SVM svm, double val){
    (*svm)->setGamma(val);
}

void SVM_SetKernel (SVM svm, int kernelType){
    (*svm)->setKernel(kernelType);
}

void SVM_SetNu (SVM svm, double val){
    (*svm)->setNu(val);
}

void SVM_SetP (SVM svm, double val){
    (*svm)->setP(val);
}

void SVM_SetTermCriteria(SVM svm, TermCriteria val){
    (*svm)->setTermCriteria(*val);
}

void SVM_SetType(SVM svm, int val){
    (*svm)->setType(val);
}

ParamGrid SVM_GetDefaultGridPtr(int param_id){
    return new cv::Ptr<cv::ml::ParamGrid>(
        cv::ml::SVM::getDefaultGridPtr(param_id)
    );
}

bool SVM_TrainAuto0(SVM svm, Mat samples, int layout, Mat responses, int kFold, ParamGrid Cgrid,
    ParamGrid gammaGrid, ParamGrid pGrid, ParamGrid nuGrid, ParamGrid coeffGrid,
    ParamGrid degreeGrid, bool balanced){
    
    return (*svm)->trainAuto(
        *samples, layout, *responses, kFold, *Cgrid, *gammaGrid, *pGrid,
        *nuGrid, *coeffGrid, *degreeGrid, balanced
    );
}

ParamGrid ParamGrid_Create (double minVal, double maxVal, double logstep){
    return new cv::Ptr<cv::ml::ParamGrid>(cv::ml::ParamGrid::create(minVal, maxVal, logstep));
}

double ParamGrid_MinVal (ParamGrid pg){
    return (*pg)->minVal;
}

double ParamGrid_MaxVal (ParamGrid pg){
    return (*pg)->maxVal;
}

double ParamGrid_LogStep (ParamGrid pg){
    return (*pg)->logStep;
}
