/*
Copyright (c) 2019 Ferhat Kurtulmuş
Boost Software License - Version 1.0 - August 17th, 2003
Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:
The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

module opencvd.cvcore;

import core.stdc.stdint;

struct Size {
    int rows;
    int cols;
    alias height = rows;
    alias width = cols;
}

struct ByteArray {
    ubyte* data;
    int length;
}

struct Scalar {
    double val1;
    double val2;
    double val3;
    double val4;
    
    static Scalar all(double val){
        return Scalar(val,val,val,val);
    }
    
    double opIndex(int i){
        return [val1, val2, val3, val4][i];
    }
    
    void opIndexAssign(double val, int i){
        *[&val1, &val2, &val3, &val4][i] = val;
    }
}

alias Color = Scalar;

struct Vec4f {
    float val1;
    float val2;
    float val3;
    float val4;
    
    static Scalar all(float val){
        return Scalar(val,val,val,val);
    }
    
    float opIndex(int i){
        return [val1, val2, val3, val4][i];
    }
    
    void opIndexAssign(float val, int i){
        *[&val1, &val2, &val3, &val4][i] = val;
    }
}

struct Vec4fs {
    Vec4f* vec4fs;
    int length;
    
    Vec4f opIndex(int i){
        return vec4fs[i];
    }
}

struct Vec3f {
    float val1;
    float val2;
    float val3;
    
    static Vec3f all(float val){
        return Vec3f(val,val,val);
    }
    
    float opIndex(int i){
        return [val1, val2, val3][i];
    }
    
    void opIndexAssign(float val, int i){
        *[&val1, &val2, &val3][i] = val;
    }
}

struct Vec3fs{
    Vec3f* vec3fs;
    int length;
    
    Vec3f opIndex(int i){
        return vec3fs[i];
    }
}

struct Vec4i {
    int val1;
    int val2;
    int val3;
    int val4;
    
    static Vec4i all(int val){
        return Vec4i(val,val,val,val);
    }
    
    int opIndex(int i){
        return [val1, val2, val3, val4][i];
    }
    
    void opIndexAssign(int val, int i){
        *[&val1, &val2, &val3, &val4][i] = val;
    }
}

struct Vec4is{
    Vec4i* vec4is;
    int length;
    
    Vec4i opIndex(int i){
        return vec4is[i];
    }
}

struct Vec3i {
    int val1;
    int val2;
    int val3;
    
    static Vec3i all(int val){
        return Vec3i(val,val,val);
    }
    
    int opIndex(int i){
        return [val1, val2, val3][i];
    }
    
    void opIndexAssign(int val, int i){
        *[&val1, &val2, &val3][i] = val;
    }
}

struct Vec3is {
    Vec3i* vec3is;
    int length;
    
    Vec3i opIndex(int i){
        return vec3is[i];
    }
}

struct Vec2f {
    float val1;
    float val2;
    
    static Vec2f all(float val){
        return Vec2f(val,val);
    }
    
    float opIndex(int i){
        return [val1, val2][i];
    }
    
    void opIndexAssign(float val, int i){
        *[&val1, &val2][i] = val;
    }
    
}

struct Vec2fs {
    Vec2f* vec2fs;
    int length;
    
    Vec2f opIndex(int i){
        return vec2fs[i];
    }
}

struct Hierarchy {
    Scalar* scalars;
    int length;
    
    Scalar opIndex(int i){
        return scalars[i];
    }
}

alias Colors = Hierarchy;

struct IntVector {
    int* val;
    int length;
    
    int opIndex(int i){
        return val[i];
    }
}

struct FloatVector {
    float* val;
    int length;
    
    float opIndex(int i){
        return val[i];
    }
}

struct Rect {
    int x;
    int y;
    int width;
    int height;
}

struct Rects {
    Rect* rects;
    int length;
    
    Rect opIndex(int i){
        return rects[i];
    }
}

struct RotatedRect {
    Contour pts;
    Rect boundingRect;
    Point center;
    Size size;
    double angle;
}

struct Point {
    int x;
    int y;

    int opCmp(Point rhs) {
        if (x < rhs.x) return -1;
        if (rhs.x < x) return 1;
        return 0;
    }

    void toString(scope void delegate(const(char)[]) sink) const {
        import std.format;
        sink("(");
        formattedWrite(sink, "%d", x);
        sink(",");
        formattedWrite(sink, "%d", y);
        sink(")");
    }
}

struct Point2f {
    float x;
    float y;
}

struct Points {
    Point* points;
    int length;
    
    Point opIndex(int i){
        return points[i];
    }
}

alias Contour = Points;

struct Contours {
    Contour* contours;
    int length;
    
    Contour opIndex(int i){
        return contours[i];
    }
}

struct KeyPoint {
    double x;
    double y;
    double size;
    double angle;
    double response;
    int octave;
    int classID;
}

struct KeyPoints {
    KeyPoint* keypoints;
    int length;
    
    KeyPoint opIndex(int i){
        return keypoints[i];
    }
}

struct DMatch {
    int queryIdx;
    int trainIdx;
    int imgIdx;
    float distance;
}

struct DMatches {
    DMatch* dmatches;
    int length;
    
    DMatch opIndex(int i){
        return dmatches[i];
    }
}

struct MultiDMatches {
    DMatches* dmatches;
    int length;
    
    DMatches opIndex(int i){
        return dmatches[i];
    }
}

struct Moment {
    double m00;
    double m10;
    double m01;
    double m20;
    double m11;
    double m02;
    double m30;
    double m21;
    double m12;
    double m03;

    double mu20;
    double mu11;
    double mu02;
    double mu30;
    double mu21;
    double mu12;
    double mu03;

    double nu20;
    double nu11;
    double nu02;
    double nu30;
    double nu21;
    double nu12;
    double nu03;
}

struct Mat {
    void* p;
    
    int rows() {return Mat_Rows(this);}
    int cols() {return Mat_Cols(this);}
    int type() {return Mat_Type(this);}
    int channels(){return Mat_Channels(this);}
    int step() {return Mat_Step(this);}
    int height() {return rows();}
    int width() {return cols();}
    int total() {return Mat_Total(this);}
    int flatLength() {return Mat_FlatLength(this);}
    void* rawDataPtr() {return Mat_DataPtrNoCast(this);}
    Scalar mean() {return Mat_Mean(this);}
    Mat sqrt() {return Mat_Sqrt(this);}
    
    Mat opCall(Rect r){
        return matFromRect(this, r);
    }
    
    static Mat opCall(){
        return newMat();
    }
    
    static Mat opCall(int rows, int cols, int mt ){
        return Mat_NewWithSize(rows, cols, mt);
    }
    
    static Mat opCall( const Scalar ar, int type){
        return Mat_NewFromScalar(ar, type);
    }

    static Mat opCall(const Scalar ar, int rows, int cols, int type){
        return Mat_NewWithSizeFromScalar(ar, rows, cols, type);
    }

    static Mat opCall(int rows, int cols, int type, ByteArray buf){
        return Mat_NewFromBytes(rows, cols, type, buf);
    }

    static Mat opCall(Mat m, int rows, int cols, int type, int prows, int pcols){
        return Mat_FromPtr(m, rows, cols, type, prows, pcols);
    }

    static Mat opCall(int rows, int cols, int type, void* data){
        return Mat_FromArrayPtr(rows, cols, type, data);
    }
    
    void opAssign(Color c){
        this.setTo(c);
    }
    
    Mat opMul(ubyte a){
        multiplyUChar(this, a);
        return this;
    }
    
    Mat opMul(int a){
        Mat_MultiplyInt(this, a);
        return this;
    }
    
    Mat opMul(float a){
        Mat_MultiplyFloat(this, a);
        return this;
    }
    
    Mat opBinary(string op)(float a){
        static if (op == "/"){
            Mat_MultiplyFloat(this, 1.0f/a);
            return this;
        }
        else static if (op == "+"){
            Mat_AddFloat(this, a);
            return this;
        }
        else static if (op == "-"){
            Mat_SubtractFloat(this, a);
            return this;
        }
    }
    
    Mat opMul(double a){
        Mat_MultiplyDouble(this, a);
        return this;
    }
    
    Mat opBinary(string op)(int a){
        static if (op == "/"){
            Mat_DivideInt(this, a);
            return this;
        }
        else static if (op == "+"){
            Mat_AddInt(this, a);
            return this;
        }
        else static if (op == "-"){
            Mat_SubtractInt(this, a);
            return this;
        }
    }
    
    Mat opBinary(string op)(double a){
        static if (op == "/"){
            Mat_MultiplyDouble(this, 1.0/a);
            return this;
        }
        else static if (op == "+"){
            Mat_AddDouble(this, a);
            return this;
        }
        else static if (op == "-"){
            Mat_SubtractDouble(this, a);
            return this;
        }
    }
    
    Mat opBinary(string op)(Mat m){
        static if (op == "+"){
            add(this, m, this);
        }
        else static if (op == "-"){
            matSubtract(this, m, this);
            return this;
        }
        return this;
    }
    
    Mat opMul(Mat m){
        Mat_Multiply(this, m, this);
        return this;
    }
    
    string type2str(){
        import std.conv;
        auto chr = _type2str(type());
        string stype = chr.to!string;
        destroy(chr);
        return stype;
    }

    ByteArray byteArray(){
        return Mat_DataPtr(this);
    }

    // retuns d array. use it like: double[] myarray = mat.array!double;
    T[] array(T)(){
        T* ret = cast(T*)rawDataPtr();
        return ret[0..flatLength()];
    }
    
    Scalar opIndex(int row, int col){
        return at(row, col);
    }
    
    /* Setters */
    void opIndexAssign(Scalar color, int row, int col){
        Mat_SetColorAt(this, color, row, col);
    }
    
    void setColorAt(Scalar color, int row, int col){
        Mat_SetColorAt(this, color, row, col);
    }
    
    
    void setUCharAt(int row, int col, ubyte val){
        assert((row < rows()) && (col < cols()), "index out of bounds!");
        Mat_SetUChar(this, row, col, val);
    }

    void setUChar3At( int x, int y, int z, ubyte val){
        // assert((x < rows()) && (y < cols()) && (z < channels()), "index out of bounds!"); // ??
        Mat_SetUChar3(this, x, y, z, val);
    }

    void setSCharAt(int row, int col, byte val){
        assert((row < rows()) && (col < cols()), "index out of bounds!");
        Mat_SetSChar(this, row, col, val);
    }

    void setSChar3At(int x, int y, int z, byte val){
        Mat_SetSChar3(this, x, y, z, val);
    }
    
    void setShortAt(int row, int col, short val){
        assert((row < rows()) && (col < cols()), "index out of bounds!");
        Mat_SetShort(this, row, col, val);    
    }
    
    void setShort3At(int x, int y, int z, short val){
        Mat_SetShort3(this, x, y, z, val);   
    }
    
    void setIntAt(int row, int col, int val){
        assert((row < rows()) && (col < cols()), "index out of bounds!");
        Mat_SetInt(this, row, col, val);
    }
    
    void setInt3At(int x, int y, int z, int val){
        Mat_SetInt3(this, x, y, z, val);
    }
    
    void setFloatAt(int row, int col, float val){
        assert((row < rows()) && (col < cols()), "index out of bounds!");
        Mat_SetFloat(this, row, col, val);
    }
    
    void setFloat3At(int x, int y, int z, float val){
        Mat_SetFloat3(this, x, y, z, val);
    }
    
    void setDoubleAt(int row, int col, double val){
        assert((row < rows()) && (col < cols()), "index out of bounds!");
        Mat_SetDouble(this, row, col, val);
    }

    void setDouble3At(int x, int y, int z, double val){
        Mat_SetDouble3(this, x, y, z, val);
    }

    /* Getters */
    
    T at(T)(int row, int col){
        assert(channels() == 1, "only single channel Mats are supported for at");
        T* ret = cast(T*)rawDataPtr();
        return ret[row * cols() + col];
    }
    
    T at(T)(int flatInd){
        assert(channels() == 1, "only single channel Mats are supported for at");
        T* ret = cast(T*)rawDataPtr();
        return ret[flatInd];
    }
    
    Color at(int row, int col){
        return Mat_ColorAt(this, row, col);
    }
    
    ubyte getUCharAt(int row, int col){
        assert((row < rows()) && (col < cols()), "index out of bounds!");
        return Mat_GetUChar(this, row, col);
    }

    ubyte getUChar3At(int x, int y, int z){
        return Mat_GetUChar3(this, x, y, z);
    }

    byte getSCharAt(int row, int col){
        assert((row < rows()) && (col < cols()), "index out of bounds!");
        return Mat_GetSChar(this, row, col);
    }

    byte getSChar3At(int x, int y, int z){
        return Mat_GetSChar3(this, x, y, z);
    }

    short getShortAt(int row, int col){
        assert((row < rows()) && (col < cols()), "index out of bounds!");
        return Mat_GetShort(this, row, col);
    }

    short getShort3At(int x, int y, int z){
        return Mat_GetShort3(this, x, y, z);
    }

    int getIntAt(int row, int col){
        assert((row < rows()) && (col < cols()), "index out of bounds!");
        return Mat_GetInt(this, row, col);
    }

    int getInt3At(int x, int y, int z){
        return Mat_GetInt3(this, x, y, z);
    }

    float getFloatAt(int row, int col){
        assert((row < rows()) && (col < cols()), "index out of bounds!");
        return Mat_GetFloat(this, row, col);
    }

    float getFloat3At(int x, int y, int z){
        return Mat_GetFloat3(this, x, y, z);
    }

    double getDoubleAt(int row, int col){
        assert((row < rows()) && (col < cols()), "index out of bounds!");
        return Mat_GetDouble(this, row, col);
    }

    double getDouble3At(int x, int y, int z){
        return Mat_GetDouble3(this, x, y, z);
    }
    
}

struct Mats {
    Mat* mats;
    int length;
    
    Mat opIndex(int i){
        return mats[i];
    }
}

enum: int {
    // MatChannels1 is a single channel Mat.
    MatChannels1 = 0,

    // MatChannels2 is 2 channel Mat.
    MatChannels2 = 8,

    // MatChannels3 is 3 channel Mat.
    MatChannels3 = 16,

    // MatChannels4 is 4 channel Mat.
    MatChannels4 = 24
}

enum: int {
    // CV8U is a Mat of 8-bit unsigned int
    CV8U = 0,

    // CV8S is a Mat of 8-bit signed int
    CV8S = 1,

    // CV16U is a Mat of 16-bit unsigned int
    CV16U = 2,

    // CV16S is a Mat of 16-bit signed int
    CV16S = 3,

    // CV16SC2 is a Mat of 16-bit signed int with 2 channels
    CV16SC2 = CV16S + MatChannels2,

    // CV32S is a Mat of 32-bit signed int
    CV32S = 4,

    // CV32F is a Mat of 32-bit float
    CV32F = 5,

    // CV64F is a Mat of 64-bit float
    CV64F = 6,

    // CV8UC1 is a Mat of 8-bit unsigned int with a single channel
    CV8UC1 = CV8U + MatChannels1,

    // CV8UC2 is a Mat of 8-bit unsigned int with 2 channels
    CV8UC2 = CV8U + MatChannels2,

    // MatTypeCV8UC3 is a Mat of 8-bit unsigned int with 3 channels
    CV8UC3 = CV8U + MatChannels3,

    // MatTypeCV8UC4 is a Mat of 8-bit unsigned int with 4 channels
    CV8UC4 = CV8U + MatChannels4
}

alias MatType = int;

private extern (C) {
    Mat Mat_New();
    Mat Mat_NewWithSize(int rows, int cols, int type);
    Mat Mat_NewFromScalar(const Scalar ar, int type);
    Mat Mat_NewWithSizeFromScalar(const Scalar ar, int rows, int cols, int type);
    Mat Mat_NewFromBytes(int rows, int cols, int type, ByteArray buf);
    Mat Mat_FromPtr(Mat m, int rows, int cols, int type, int prows, int pcols);
    Mat Mat_FromArrayPtr(int rows, int cols, int type, void* data);
    
    int Mat_Rows(Mat m);
    int Mat_Cols(Mat m);
    int Mat_Type(Mat m);
    int Mat_Channels(Mat m);
    int Mat_Step(Mat m);
    
    char* _type2str(int type);

    ByteArray Mat_DataPtr(Mat m);
    int Mat_FlatLength(Mat src);
    void* Mat_DataPtrNoCast(Mat src);
    Scalar Mat_ColorAt(Mat src, int row, int col);
    
    Mat Mat_Reshape(Mat m, int cn, int rows);

    void Mat_Close(Mat m);
    int Mat_Empty(Mat m);
    Mat Mat_Clone(Mat m);
    void Mat_CopyTo(Mat m, Mat dst);
    void Mat_CopyToWithMask(Mat m, Mat dst, Mat mask);
    void Mat_ConvertTo(Mat m, Mat dst, int type);
    void Mat_convertTo2(Mat m, Mat dst, int rtype, double alpha, double beta);

    int Mat_Total(Mat m);
    Scalar Mat_Mean(Mat m);
    Mat Mat_Sqrt(Mat m);
    
    void Mat_SetColorAt(Mat src, Scalar color, int row, int col);
    void Mat_SetTo(Mat m, Scalar value);
    void Mat_SetUChar(Mat m, int row, int col, uint8_t val);
    void Mat_SetUChar3(Mat m, int x, int y, int z, uint8_t val);
    void Mat_SetSChar(Mat m, int row, int col, int8_t val);
    void Mat_SetSChar3(Mat m, int x, int y, int z, int8_t val);
    void Mat_SetShort(Mat m, int row, int col, int16_t val);
    void Mat_SetShort3(Mat m, int x, int y, int z, int16_t val);
    void Mat_SetInt(Mat m, int row, int col, int32_t val);
    void Mat_SetInt3(Mat m, int x, int y, int z, int32_t val);
    void Mat_SetFloat(Mat m, int row, int col, float val);
    void Mat_SetFloat3(Mat m, int x, int y, int z, float val);
    void Mat_SetDouble(Mat m, int row, int col, double val);
    void Mat_SetDouble3(Mat m, int x, int y, int z, double val);

    uint8_t Mat_GetUChar(Mat m, int row, int col);
    uint8_t Mat_GetUChar3(Mat m, int x, int y, int z);
    int8_t Mat_GetSChar(Mat m, int row, int col);
    int8_t Mat_GetSChar3(Mat m, int x, int y, int z);
    int16_t Mat_GetShort(Mat m, int row, int col);
    int16_t Mat_GetShort3(Mat m, int x, int y, int z);
    int32_t Mat_GetInt(Mat m, int row, int col);
    int32_t Mat_GetInt3(Mat m, int x, int y, int z);
    float Mat_GetFloat(Mat m, int row, int col);
    float Mat_GetFloat3(Mat m, int x, int y, int z);
    double Mat_GetDouble(Mat m, int row, int col);
    double Mat_GetDouble3(Mat m, int x, int y, int z);

    Mat Mat_Region(Mat m, Rect r);
    void Mat_PatchNaNs(Mat m);
    
    void Mat_MultiplyInt(Mat m, int val);
    void Mat_DivideInt(Mat m, int val);
    void Mat_AddDouble(Mat m, double val);
    void Mat_SubtractDouble(Mat m, double val);
    void Mat_AddInt(Mat m, int val);
    void Mat_SubtractInt(Mat m, int val);
    
    void Mat_AddUChar(Mat m, uint8_t val);
    void Mat_SubtractUChar(Mat m, uint8_t val);
    void Mat_MultiplyUChar(Mat m, uint8_t val);
    void Mat_DivideUChar(Mat m, uint8_t val);
    void Mat_AddFloat(Mat m, float val);
    void Mat_SubtractFloat(Mat m, float val);
    void Mat_MultiplyFloat(Mat m, float val);
    void Mat_MultiplyDouble(Mat m, double val);
    void Mat_DivideFloat(Mat m, float val);

    void LUT(Mat src, Mat lut, Mat dst);

    void Mat_AbsDiff(Mat src1, Mat src2, Mat dst);
    void Mat_Add(Mat src1, Mat src2, Mat dst);
    void Mat_AddWeighted(Mat src1, double alpha, Mat src2, double beta, double gamma, Mat dst);
    void Mat_BitwiseAnd(Mat src1, Mat src2, Mat dst);
    void Mat_BitwiseAndWithMask(Mat src1, Mat src2, Mat dst, Mat mask);
    void Mat_BitwiseNot(Mat src1, Mat dst);
    void Mat_BitwiseNotWithMask(Mat src1, Mat dst, Mat mask);
    void Mat_BitwiseOr(Mat src1, Mat src2, Mat dst);
    void Mat_BitwiseOrWithMask(Mat src1, Mat src2, Mat dst, Mat mask);
    void Mat_BitwiseXor(Mat src1, Mat src2, Mat dst);
    void Mat_BitwiseXorWithMask(Mat src1, Mat src2, Mat dst, Mat mask);
    void Mat_Compare(Mat src1, Mat src2, Mat dst, int ct);
    void Mat_CompareWithScalar(Mat src1, Scalar src2, Mat dst, int ct);
    void Mat_BatchDistance(Mat src1, Mat src2, Mat dist, int dtype, Mat nidx, int normType, int K, Mat mask, int update, bool crosscheck);
    int Mat_BorderInterpolate(int p, int len, int borderType);
    void Mat_CalcCovarMatrix(Mat samples, Mat covar, Mat mean, int flags, int ctype);
    void Mat_CartToPolar(Mat x, Mat y, Mat magnitude, Mat angle, bool angleInDegrees);
    bool Mat_CheckRange(Mat m);
    void Mat_CompleteSymm(Mat m, bool lowerToUpper);
    void Mat_ConvertScaleAbs(Mat src, Mat dst, double alpha, double beta);
    void Mat_CopyMakeBorder(Mat src, Mat dst, int top, int bottom, int left, int right, int borderType, Scalar value);
    int Mat_CountNonZero(Mat src);
    void Mat_DCT(Mat src, Mat dst, int flags);
    double Mat_Determinant(Mat m);
    void Mat_DFT(Mat m, Mat dst, int flags);
    void Mat_Divide(Mat src1, Mat src2, Mat dst);
    bool Mat_Eigen(Mat src, Mat eigenvalues, Mat eigenvectors);
    void Mat_EigenNonSymmetric(Mat src, Mat eigenvalues, Mat eigenvectors);
    void Mat_Exp(Mat src, Mat dst);
    void Mat_ExtractChannel(Mat src, Mat dst, int coi);
    void Mat_FindNonZero(Mat src, Mat idx);
    void Mat_Flip(Mat src, Mat dst, int flipCode);
    void Mat_Gemm(Mat src1, Mat src2, double alpha, Mat src3, double beta, Mat dst, int flags);
    int Mat_GetOptimalDFTSize(int vecsize);
    void Mat_Hconcat(Mat src1, Mat src2, Mat dst);
    void Mat_Vconcat(Mat src1, Mat src2, Mat dst);
    void Rotate(Mat src, Mat dst, int rotationCode);
    void Mat_Idct(Mat src, Mat dst, int flags);
    void Mat_Idft(Mat src, Mat dst, int flags, int nonzeroRows);
    void Mat_InRange(Mat src, Mat lowerb, Mat upperb, Mat dst);
    void Mat_InRangeWithScalar(Mat src, const Scalar lowerb, const Scalar upperb, Mat dst);
    void Mat_InsertChannel(Mat src, Mat dst, int coi);
    double Mat_Invert(Mat src, Mat dst, int flags);
    void Mat_Log(Mat src, Mat dst);
    void Mat_Magnitude(Mat x, Mat y, Mat magnitude);
    void Mat_Max(Mat src1, Mat src2, Mat dst);
    void Mat_MeanStdDev(Mat src, Mat dstMean, Mat dstStdDev);
    void Mat_Merge(Mats mats, Mat dst);
    void Mat_Min(Mat src1, Mat src2, Mat dst);
    void Mat_MinMaxIdx(Mat m, double* minVal, double* maxVal, int* minIdx, int* maxIdx);
    void Mat_MinMaxLoc(Mat m, double* minVal, double* maxVal, Point* minLoc, Point* maxLoc);
    void Mat_MinMaxLoc2(Mat a, double* minVal, double* maxVal, int* minIdx, int* maxIdx);
    void Mat_MulSpectrums(Mat a, Mat b, Mat c, int flags);
    void Mat_Multiply(Mat src1, Mat src2, Mat dst);
    void Mat_Normalize(Mat src, Mat dst, double alpha, double beta, int typ);
    double Norm(Mat src1, int normType);
    void Mat_PerspectiveTransform(Mat src, Mat dst, Mat tm);
    bool Mat_Solve(Mat src1, Mat src2, Mat dst, int flags);
    int Mat_SolveCubic(Mat coeffs, Mat roots);
    double Mat_SolvePoly(Mat coeffs, Mat roots, int maxIters);
    void Mat_Reduce(Mat src, Mat dst, int dim, int rType, int dType);
    void Mat_Repeat(Mat src, int nY, int nX, Mat dst);
    void Mat_ScaleAdd(Mat src1, double alpha, Mat src2, Mat dst);
    void Mat_Sort(Mat src, Mat dst, int flags);
    void Mat_SortIdx(Mat src, Mat dst, int flags);
    void Mat_Split(Mat src, Mats* mats);
    void Mat_Subtract(Mat src1, Mat src2, Mat dst);
    Scalar Mat_Trace(Mat src);
    void Mat_Transform(Mat src, Mat dst, Mat tm);
    void Mat_Transpose(Mat src, Mat dst);
    void Mat_PolarToCart(Mat magnitude, Mat degree, Mat x, Mat y, bool angleInDegrees);
    void Mat_Pow(Mat src, double power, Mat dst);
    void Mat_Phase(Mat x, Mat y, Mat angle, bool angleInDegrees);
    Scalar Mat_Sum(Mat src1);

    TermCriteria TermCriteria_New(int typ, int maxCount, double epsilon);

    int64_t GetCVTickCount();
    double GetTickFrequency();
    
    Mat Mat_ZerosFromRC(int rows, int cols, int type);
    Mat Mat_ZerosFromSize(Size sz, int type);
    Mat Mat_OnesFromRC(int rows, int cols, int type);
    Mat Mat_OnesFromSize(Size sz, int type);
    
    double Mat_Dot(Mat m1, Mat m2); // TODO: implement operator overload
    Mat Mat_Diag(Mat src, int d);
    Mat Mat_EyeFromRC(int rows, int cols, int type);
}


Mat newMat(){
    return Mat_New();
}

Mat newMatWithSize( int rows, int cols, int mt ){
    return Mat_NewWithSize(rows, cols, mt);
}

Mat newMatFromScalar( const Scalar ar, int type){
    return Mat_NewFromScalar(ar, type);
}

Mat newMatWithSizeFromScalar(const Scalar ar, int rows, int cols, int type){
    return Mat_NewWithSizeFromScalar(ar, rows, cols, type);
}

Mat newMatFromBytes(int rows, int cols, int type, ByteArray buf){
    return Mat_NewFromBytes(rows, cols, type, buf);
}

Mat newMatFromPtr(Mat m, int rows, int cols, int type, int prows, int pcols){
    return Mat_FromPtr(m, rows, cols, type, prows, pcols);
}

Mat newMatFromArrayPtr(int rows, int cols, int type, void* data){
    return Mat_FromArrayPtr(rows, cols, type, data);
}

Mat zeros(int rows, int cols, int type){
    return Mat_ZerosFromRC(rows, cols, type);
}

Mat zeros(Size sz, int type){
    return Mat_ZerosFromSize(sz, type);
}

Mat ones(int rows, int cols, int type){
    return Mat_OnesFromRC(rows, cols, type);
}
Mat ones(Size sz, int type){
    return Mat_OnesFromSize(sz, type);
}

Size getSize(Mat m){
    return Size(m.rows, m.cols);
}

Mat reshape(Mat m, int cn, int rows){
    return Mat_Reshape( m, cn, rows);
}

void Destroy(Mat m){
    Mat_Close(m);
}

bool isEmpty(Mat m){
    return Mat_Empty(m) == 0 ? false: true;
}

alias empty = isEmpty;

Mat clone(Mat m){
    return Mat_Clone(m);
}

void copyTo(Mat m, Mat dst){
    Mat_CopyTo(m, dst);
}

void copyToWithMask(Mat m, Mat dst, Mat mask){
    Mat_CopyToWithMask(m, dst, mask);
}

void convertTo(Mat m, Mat dst, int type){
    Mat_ConvertTo(m, dst, type);
}

void convertTo(Mat m, Mat dst, int rtype, double alpha = 1, double beta = 0 ){
    Mat_convertTo2(m, dst, rtype, alpha, beta);
}

void setTo(Mat m, Scalar s){
    Mat_SetTo(m, s);
}

void patchNaNs(Mat m){
    Mat_PatchNaNs(m);
}

Mat matFromRect(Mat m, Rect r){
    return Mat_Region(m, r);
}

alias subImageFromROI = matFromRect;

void addUChar(Mat m, ubyte val){
    Mat_AddUChar(m, val);
}

void subtractUChar(Mat m, ubyte val){
    Mat_SubtractUChar(m, val);
}

void multiplyUChar(Mat m, ubyte val){
    Mat_MultiplyUChar(m, val);
}

void divideUChar(Mat m, ubyte val){
    Mat_DivideUChar(m, val);
}

void addFloat(Mat m, float val){
    Mat_AddFloat(m, val);
}

void subtractFloat(Mat m, float val){
    Mat_SubtractFloat(m, val);
}

void multiplyFloat(Mat m, float val){
    multiplyFloat(m, val);
}

void multiplyDouble(Mat m, double val){
    Mat_MultiplyDouble(m, val);
}

void divideFloat(Mat m, float val){
    Mat_DivideFloat(m, val);
}

void multiplyInt(Mat m, int val){
    Mat_MultiplyInt(m, val);
}

void divideInt(Mat m, int val){
    Mat_DivideInt(m, val);
}

void addDouble(Mat m, double val){
    Mat_AddDouble(m, val);
}

void subtractDouble(Mat m, double val){
    Mat_SubtractDouble(m, val);
}

void addInt(Mat m, int val){
    Mat_AddInt(m, val);
}

void subtractInt(Mat m, int val){
    Mat_SubtractInt(m, val);
}


void performLUT(Mat src, Mat lut, Mat dst){
    LUT(src, lut, dst);
}

void absDiff(Mat src1, Mat src2, Mat dst){
    Mat_AbsDiff(src1, src2, dst);
}

void add(Mat src1, Mat src2, Mat dst){
    Mat_Add(src1, src2, dst);
}

void addWeighted(Mat src1, double alpha, Mat src2, double beta, double gamma, Mat dst){
    Mat_AddWeighted(src1, alpha, src2, beta, gamma, dst);
}

void bitwiseAnd(Mat src1, Mat src2, Mat dst){
    Mat_BitwiseAnd(src1, src2, dst);
}

void bitwiseAndWithMask(Mat src1, Mat src2, Mat dst, Mat mask){
    Mat_BitwiseAndWithMask(src1, src2, dst, mask);
}

void bitwiseNot(Mat src1, Mat dst){
    Mat_BitwiseNot(src1, dst);
}

void bitwiseNotWithMask(Mat src1, Mat dst, Mat mask){
    Mat_BitwiseNotWithMask(src1, dst, mask);
}

void bitwiseOr(Mat src1, Mat src2, Mat dst){
    Mat_BitwiseOr(src1, src2, dst);
}

void bitwiseOrWithMask(Mat src1, Mat src2, Mat dst, Mat mask){
    Mat_BitwiseOrWithMask(src1, src2, dst, mask);
}

void bitwiseXor(Mat src1, Mat src2, Mat dst){
    Mat_BitwiseXor(src1, src2, dst);
}

void bitwiseXorWithMask(Mat src1, Mat src2, Mat dst, Mat mask){
    Mat_BitwiseXorWithMask(src1, src2, dst, mask);
}

enum: int {
    // enum cv::CmpTypes
    CMP_EQ,
    CMP_GT,
    CMP_GE,
    CMP_LT,
    CMP_LE,
    CMP_NE,
}

void compare(Mat src1, Mat src2, Mat dst, int ct){
    Mat_Compare(src1, src2, dst, ct);
}

void compare(Mat src1, Scalar src2, Mat dst, int ct){
    Mat_CompareWithScalar(src1, src2, dst, ct);
}

void batchDistance(Mat src1, Mat src2, Mat dist, int dtype, Mat nidx, int normType, int K, Mat mask, int update, bool crosscheck){
    Mat_BatchDistance(src1, src2, dist, dtype, nidx, normType, K, mask, update, crosscheck);
}

enum: int {
	// CovarScrambled indicates to scramble the results.
	CovarScrambled = 0,

	// CovarNormal indicates to use normal covariation.
	CovarNormal = 1,

	// CovarUseAvg indicates to use average covariation.
	CovarUseAvg = 2,

	// CovarScale indicates to use scaled covariation.
	CovarScale = 4,

	// CovarRows indicates to use covariation on rows.
	CovarRows = 8,

	// CovarCols indicates to use covariation on columns.
	CovarCols = 16,
}
alias CovarFlags = int;

int borderInterpolate(int p, int len, CovarFlags borderType){
    return Mat_BorderInterpolate(p, len, borderType);
}

void calcCovarMatrix(Mat samples, Mat covar, Mat mean, CovarFlags flags, int ctype){
    Mat_CalcCovarMatrix(samples, covar, mean, flags, ctype);
}

void cartToPolar(Mat x, Mat y, Mat magnitude, Mat angle, bool angleInDegrees){
    Mat_CartToPolar(x, y, magnitude, angle, angleInDegrees);
}

bool checkRange(Mat m){
    return Mat_CheckRange(m);
}

void completeSymm(Mat m, bool lowerToUpper){
    Mat_CompleteSymm(m, lowerToUpper);
}

void convertScaleAbs(Mat src, Mat dst, double alpha, double beta){
    Mat_ConvertScaleAbs(src, dst, alpha, beta);
}

void copyMakeBorder(Mat src, Mat dst, int top, int bottom, int left, int right, CovarFlags borderType, Scalar value){
    Mat_CopyMakeBorder(src, dst, top, bottom, left, right, borderType, value);
}

enum: int {
    // DftForward performs forward 1D or 2D dft or dct.
    DftForward  = 0,

    // DftInverse performs an inverse 1D or 2D transform.
    DftInverse = 1,

    // DftScale scales the result: divide it by the number of array elements. Normally, it is combined with DFT_INVERSE.
    DftScale = 2,

    // DftRows performs a forward or inverse transform of every individual row of the input matrix.
    DftRows = 4,

    // DftComplexOutput performs a forward transformation of 1D or 2D real array; the result, though being a complex array, has complex-conjugate symmetry
    DftComplexOutput = 16,

    // DftRealOutput performs an inverse transformation of a 1D or 2D complex array; the result is normally a complex array of the same size,
    // however, if the input array has conjugate-complex symmetry (for example, it is a result of forward transformation with DFT_COMPLEX_OUTPUT flag),
    // the output is a real array.
    DftRealOutput = 32,

    // DftComplexInput specifies that input is complex input. If this flag is set, the input must have 2 channels.
    DftComplexInput = 64,

    // DctInverse performs an inverse 1D or 2D dct transform.
    DctInverse = DftInverse,

    // DctRows performs a forward or inverse dct transform of every individual row of the input matrix.
    DctRows = DftRows
}

alias DftFlags = int;

int countNonZero(Mat src){
    return Mat_CountNonZero(src);
}

void DCT(Mat src, Mat dst, int flags){
    Mat_DCT(src, dst, flags);
}

double determinant(Mat m){
    return Mat_Determinant(m);
}

void DFT(Mat m, Mat dst, DftFlags flags){
    Mat_DFT(m, dst, flags);
}

void divide(Mat src1, Mat src2, Mat dst){
    Mat_Divide(src1, src2, dst);
}

bool eigen(Mat src, Mat eigenvalues, Mat eigenvectors){
    return Mat_Eigen(src, eigenvalues, eigenvectors);
}

void eigenNonSymmetric(Mat src, Mat eigenvalues, Mat eigenvectors){
    Mat_EigenNonSymmetric(src, eigenvalues, eigenvectors);
}

void matExp(Mat src, Mat dst){
    Mat_Exp(src, dst);
}

void extractChannel(Mat src, Mat dst, int coi){
    Mat_ExtractChannel(src, dst, coi);
}

void findNonZero(Mat src, Mat idx){
    Mat_FindNonZero(src, idx);
}

void flip(Mat src, Mat dst, int flipCode){
    Mat_Flip(src, dst, flipCode);
}

void gemm(Mat src1, Mat src2, double alpha, Mat src3, double beta, Mat dst, int flags){
    Mat_Gemm(src1, src2, alpha, src3, beta, dst, flags);
}

int getOptimalDFTSize(int vecsize){
    return Mat_GetOptimalDFTSize(vecsize);
}

void hconcat(Mat src1, Mat src2, Mat dst){
    Mat_Hconcat(src1, src2, dst);
}

void vconcat(Mat src1, Mat src2, Mat dst){
    Mat_Vconcat(src1, src2, dst);
}

void rotate(Mat src, Mat dst, int rotationCode){
    Rotate(src, dst, rotationCode);
}

void idct(Mat src, Mat dst, int flags){
    Mat_Idct(src, dst, flags);
}

void idft(Mat src, Mat dst, int flags, int nonzeroRows){
    Mat_Idft(src, dst, flags, nonzeroRows);
}

void inRange(Mat src, Mat lowerb, Mat upperb, Mat dst){
    Mat_InRange(src, lowerb, upperb, dst);
}

void inRange(Mat src, const Scalar lowerb, const Scalar upperb, Mat dst){
    Mat_InRangeWithScalar(src, lowerb, upperb, dst);
}

void insertChannel(Mat src, Mat dst, int coi){
    Mat_InsertChannel(src, dst, coi);
}

double invert(Mat src, Mat dst, int flags){
    return Mat_Invert(src, dst, flags);
}

void matLog(Mat src, Mat dst){
    Mat_Log(src, dst);
}

void magnitude(Mat x, Mat y, Mat magnitude){
    Mat_Magnitude(x, y, magnitude);
}

void matMax(Mat src1, Mat src2, Mat dst){
    Mat_Max(src1, src2, dst);
}

void meanStdDev(Mat src, Mat dstMean, Mat dstStdDev){
    Mat_MeanStdDev(src, dstMean, dstStdDev);
}

void merge(Mats mats, Mat dst){
    Mat_Merge(mats, dst);
}

void matMin(Mat src1, Mat src2, Mat dst){
    Mat_Min(src1, src2, dst);
}

void minMaxIdx(Mat m, double* minVal, double* maxVal, int* minIdx, int* maxIdx){
    Mat_MinMaxIdx(m, minVal, maxVal, minIdx, maxIdx);
}

void minMaxLoc(Mat m, double* minVal, double* maxVal, Point* minLoc, Point* maxLoc){
    Mat_MinMaxLoc(m, minVal, maxVal, minLoc, maxLoc);
}

void minMaxLoc(Mat a, double* minVal, double* maxVal, int* minIdx, int* maxIdx){
    Mat_MinMaxLoc2(a, minVal, maxVal, minIdx, maxIdx);
}

void mulSpectrums(Mat a, Mat b, Mat c, int flags){
    Mat_MulSpectrums(a, b, c, flags);
}

void multiply(Mat src1, Mat src2, Mat dst){
    Mat_Multiply(src1, src2, dst);
}

void subtract(Mat src1, Mat src2, Mat dst){
    Mat_Subtract(src1, src2, dst);
}

enum: int {// cv::NormTypes
    NORM_INF = 1, 
    NORM_L1 = 2, 
    NORM_L2 = 4, 
    NORM_L2SQR = 5, 
    NORM_HAMMING = 6, 
    NORM_HAMMING2 = 7, 
    NORM_TYPE_MASK = 7, 
    NORM_RELATIVE = 8, 
    NORM_MINMAX = 32 
}

void normalize(Mat src, Mat dst, double alpha, double beta, int typ){
    Mat_Normalize(src, dst, alpha, beta, typ);
}

double norm(Mat src1, int normType){
    return Norm(src1, normType);
}

void perspectiveTransform(Mat src, Mat dst, Mat tm){
    Mat_PerspectiveTransform(src, dst, tm);
}

bool solve(Mat src1, Mat src2, Mat dst, int flags){
    return Mat_Solve(src1, src2, dst, flags);
}

int solveCubic(Mat coeffs, Mat roots){
    return Mat_SolveCubic(coeffs, roots);
}

double solvePoly(Mat coeffs, Mat roots, int maxIters){
    return Mat_SolvePoly(coeffs, roots, maxIters);
}

void reduce(Mat src, Mat dst, int dim, int rType, int dType){
    Mat_Reduce(src, dst, dim, rType, dType);
}

void repeat(Mat src, int nY, int nX, Mat dst){
    Mat_Repeat(src, nY, nX, dst);
}

void scaleAdd(Mat src1, double alpha, Mat src2, Mat dst){
    Mat_ScaleAdd(src1, alpha, src2, dst);
}

void matSort(Mat src, Mat dst, int flags){
    Mat_Sort(src, dst, flags);
}

void matSortIdx(Mat src, Mat dst, int flags){
    Mat_SortIdx(src, dst, flags);
}

void matSplit(Mat src, Mats* mats){
    Mat_Split(src, mats);
}
void matSubtract(Mat src1, Mat src2, Mat dst){
    Mat_Subtract(src1, src2, dst);
}

Scalar matTrace(Mat src){
    return Mat_Trace(src);
}

void transform(Mat src, Mat dst, Mat tm){
    Mat_Transform(src, dst, tm);
}

void transpose(Mat src, Mat dst){
    Mat_Transpose(src, dst);
}

void polarToCart(Mat magnitude, Mat degree, Mat x, Mat y, bool angleInDegrees){
    Mat_PolarToCart(magnitude, degree, x, y, angleInDegrees);
}

void matPow(Mat src, double power, Mat dst){
    Mat_Pow(src, power, dst);
}

void phase(Mat x, Mat y, Mat angle, bool angleInDegrees){
    Mat_Phase(x, y, angle, angleInDegrees);
}

Scalar matSum(Mat src1){
    return Mat_Sum(src1);
}

struct TermCriteria {
    void* p;
}

TermCriteria newTermCriteria(int typ, int maxCount, double epsilon){
    return TermCriteria_New(typ, maxCount, epsilon);
}

int64_t getCVTickCount(){
    return GetCVTickCount();
}

double getTickFrequency(){
    return GetTickFrequency();
}

double dot(Mat m1, Mat m2){
    return Mat_Dot(m1, m2);
}

Mat diag(Mat src, int d = 0){
    return Mat_Diag(src, d);
}

Mat eye(int rows, int cols, int type){
    return Mat_EyeFromRC(rows, cols, type);
}

Mat eye(Size sz, int type){
    return Mat_EyeFromRC(sz.height, sz.width, type);
}
