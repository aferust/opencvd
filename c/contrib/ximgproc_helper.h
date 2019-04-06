
#ifdef __cplusplus
#include <opencv2/opencv.hpp>
#include <opencv2/ximgproc.hpp>
extern "C" {
#endif

#include "../core.h"

void FourierDescriptor(Contour src, Mat dst, int nbElt, int nbFD);
void Thinning(Mat input, Mat output, int thinningType);

#ifdef __cplusplus
}
#endif
