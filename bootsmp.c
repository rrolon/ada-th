/* *************** Bootstrap Sampling ****************** */

/* The aim of this mex file is twofold. First as an introduction to Mex file programing,
and in the second place to speed up one of the most time consuming task in the adaboost
algorithm...
 
After a 2 hole days trying to make it work, finally I did it!
Author: Maximiliano Rodriguez
12/02/2008                      */

#include "math.h"
#include "stdio.h"
#include "mex.h"
#include "matrix.h"
#include "stdlib.h"


void mexFunction(int nout, mxArray *outputs[], int nin, const mxArray *inputs[])
{
    /* nout: Number of outputs
     * min: Number of inputs
     * outputs: Pointer to outputs
     * inputs: Pointer to inputs
       
     *mxArray is a structure, has variable name, real and imaginary parts ...
     */
    
   /* POINTERS REVIEW
      double *dist;        -> define the pointer
      dist= new double[10] -> Allocate memory in C++
      delete[] dist;       -> only if was created with "new" in C++    
      *dist                -> the value conteined in the memory position pointed by dist
      *(dist+1)            -> the value conteined in the next memory position
      dist[i]              -> also is *dist (I don't know if it does work always)
      dist++;              -> point to the next memory position
      dist=dist-1          -> point to the previous memory position

 
      in C language is 
                  double *dist;      
                  dist= malloc(sizeof(double)*10);
                
                  free()
 
    * if you create an array with double indexing, it works only for small sizes (don't know how much)
      so it's good to work as is the "df" variable below. Don't make this if you have in mind big zises:
      
            double my_matrix[100][100];
    
    * instead do:
  
            double my_matrix[100*100];
    
   */
    
    int Ns, j;
    /*mwSize Npn, Npm, i;*/
    int Npn, Npm, i;
    
    /* Check for proper number of arguments */
    if (nin != 2) {
        mexErrMsgTxt("Two input argument required.");
    } else if (nout > 1) {
        mexErrMsgTxt("Too many output arguments.");
    }
        
    
    /* Check the sizes of arguments */
    Npm = (int) mxGetM(inputs[0]); /* mxGetM gets the number of rows*/
    Npn = (int) mxGetN(inputs[0]); /* mxGetN gets the number of columns*/
    
    if (Npn != 1) {
        mexErrMsgTxt("Bad size in argument 1, Should be Nx1.");
    }
    
    Ns = (int) mxGetScalar(inputs[1]); /* mxGetScalar copy the scalar variable pointed as the second input */
   /* mexPrintf("Number of samples to choose: %d.\n", Ns);*/
    
    
    if (Ns>Npm) {
        mexErrMsgTxt("Number of samples to choose greater than patterns.");
    }
    
    
    /* Evaluate the cumulative distribution */
    double *dist; /* define a poiter */
       
    
    dist=mxGetPr(inputs[0]); /*Make the poiter signal the first input*/
     
    double *cumD; /*define poiter*/    
    cumD= malloc(sizeof(double)*Npm); /*Allocate memory*/
        
    cumD[0]=*dist; 
    for (i=1;i<Npm;i++) {
        dist++;
        cumD[i]=*dist+cumD[i-1];
    }

    
    /* Generate random vector */
    double *RandVec;
    RandVec = malloc(sizeof(double)*Ns);
    for (j=0;j<Ns;j++) {
        RandVec[j]=((double)rand() / ((double)(RAND_MAX)+(double)(1)) );
    }
    

    
    double *df;
    df = malloc(sizeof(double)*Ns*Npm);
    for (i=0;i<Npm;i++) {
        for (j=0;j<Ns;j++) {
            df[i*Ns+j]=cumD[i]-RandVec[j];
             /*   df = (df <= 0)*2+df;*/
            if (df[i*Ns+j] <= 0){
                df[i*Ns+j]=2+df[i*Ns+j];
            }
        }
    }
    
    
    /* find minimums of each column */
    /* [mins, idxs] = min(df); */
    
    double min;
    outputs[0] = mxCreateDoubleMatrix(Ns,1,mxREAL);
    double *idx=mxGetPr(outputs[0]);
    double aux;
    bool boolean;
    for (j=0;j<Ns;j++) {
        min=df[j];
        aux=1;
        *idx=aux;
        for (i=0;i<Npm;i++) {
            boolean=min>df[j+Ns*i];    
            if (boolean){               
                min=df[j+Ns*i];
                *idx=aux;
            }
            aux=aux+ (double) 1;
        }
        idx++;
        min++;
    }
    
    free(RandVec);
    free(df);
    free(cumD);    
    return;
}

