The Brain of the Storm: Using neural networks to predict hurricane severity
========================================================
author: Maddi Cowen, Ciaran Evans, and Samantha Morrison  
date:

Introduction: Storms
========================================================
Studying and understanding storms is and important area of research.

![](hurricanePatricia.jpg)

Introduction: Measuring Storms
========================================================
A wide array of technology is used to gather storm data.
![](weatherMeasurement.png)

How well can we use buoys by themselves?


NOAA and Buoys
========================================================
National Oceanographic and Atmospheric Administration (NOAA) runs National Data Buoy Center (NDBC), which maintains and operates network of buoys:

![](noaaBuoyPic.JPG)


The Role of Buoys
========================================================
![](buoy42042PicAndLoc.JPG)

Gather oceanic and atmospheric data for use in weather forecasting and assessment. Some variables collected:
- Wind speed and wind direction
- Air and water temperature
- Pressure


Project Overview
========================================================
Assess ability of buoys by themselves to estimate weather conditions of surrounding areas
- Collect data on storms in the North Atlantic
- Match each storm observation with data from nearby buoys
- Evaluate the ability of buoy measurements to predict storm wind


Data Collection
========================================================
- Goal: combine information from North Atlantic storms with meteorological data from buoys.
- Data Sources
  - Storms: NOAA Best Track Archive for Climate Stewardship (IBTrACS)
  - Buoys: NOAA National Data Buoy Center (NDBC)
  
  
Gathering Storms Data: IBTrACS
========================================================
Download CSV files for all storms data in years 2000 - 2015 from IBTrACS website, then combine into one file

![](stormByYearIBTrACS.PNG)


Gathering Storms Data: Selecting Basin
========================================================
- Select all storms in the North Atlantic basin
- Each row is a storm observation at a single location and time
- Variables in data: Latitude, Longitude, Time, Sustained Wind

![](stormCSV2015.PNG)


Gathering Buoy Data: the Buoys
========================================================
![](noaaBuoyList.JPG)

Gathering Buoy Data: Overview
========================================================
- Use ID number to choose buoys in North Atlantic
  - these buoy IDs begin with 41, 42, or 44
- Get latitude and longitude for North Atlantic buoys
- For each North Atlantic storm observation, find the nearby buoys and average their data
- Output goal:
![](exTable.PNG)


Gathering Buoy Data
========================================================
- Each buoy has a page of historical data

![](buoy42042HistoricalDataPage.JPG)

- Scrape the standard meteorogical data corresponding to location and time for each storm row, then average



Neural Networks- Perceptron
========================================================

![](simpleperceptron.PNG)

-takes binary inputs $(x_1, x_2, x_3)$ and gives one binary output

-to determine the output, each input was given a weight $(w_1, w_2, w_3)$

-the ouput of 0,1 is based on whether $\Sigma_j{ w_jx_j}$ is above or below a *threshold value*

figure and info from: 
http://neuralnetworksanddeeplearning.com/chap1.html

Neural Networks- Perceptrons
========================================================
-basic model of human decision making
![](complexperceptrons.PNG)

-first layer perceptron make 3 decisions  
-second layer perceptron weighs results from first layer

-allows for complex decisions
-each perceptron only gives one output; used as inputs to several perceptrons

http://neuralnetworksanddeeplearning.com/chap1.html

Neural Networks- decision rule
========================================================
-to describe output decision  
denote:  
$w\cdot x = \Sigma_j{ w_jx_j}$  
$bias\equiv -$ threshold

$output=\{^{0\text{ } if\text{ }  w\cdot x \text{ }  + \text{ } b\text{ }  \le\text{ }  0}_{1\text{ } if\text{ } w\cdot x \text{ }  + \text{ } b\text{ }  > \text{ }  0}$

-when bias is positive, large, "easier" to get output of 1  
-when bias negative, "harder" to get 1

-perceptrons can compute basic logical functions
http://neuralnetworksanddeeplearning.com/chap1.html

Neural Networks- learning
========================================================
-can use for *learning algorithms* that tune weights and biases  

-learning: ideally small changes in weight biases --> small change in output  

-iteratively make small changes to improve network


-does not work w/ perceptrons  

-instead use a *sigmoid* neuron
http://neuralnetworksanddeeplearning.com/chap1.html

Neural Networks- sigmoid neuron
========================================================

differences:  
-inputs $(x_1, x_2, x_3)$ continuous b/w 0, 1   
-output not 0,1
$ouput = \sigma(w\cdot x + b)$

$\sigma$ sigmoid function  
$\sigma (z) \equiv \frac{1}{1 + e^{-z}}$

$ouput = \frac{1}{1 + \exp{(-\Sigma_j{ w_jx_j-b})}}$

$z \equiv w\cdot x + b$
when z is large, positive, exponent ~ 0, $\sigma(z) \approx 1$
when z large, negative approx 0  
-similar to perceptron when z large  
http://neuralnetworksanddeeplearning.com/chap1.html

Neural Networks- sigmoid function
========================================================

![plot of chunk fig](Math154Presentation-figure/fig-1.png) 

-smoothed out step function  
-perceptron is a step function  
-smoothing --> small changes in weight, bias result in small changes in output  
http://kyrcha.info/2012/07/08/tutorials-fitting-a-sigmoid-function-in-r/  
http://neuralnetworksanddeeplearning.com/chap1.html

Neural Networks- sigmoid function
========================================================

-with sigmoid function  
$\Delta output \approx \Sigma_j{\frac{\partial output}{\partial w_j} \Delta w_j + \frac{\partial output}{\partial b} \Delta b}$  
-change in output a linear function of change in weights and bias  
http://neuralnetworksanddeeplearning.com/chap1.html

Neural Networks- multilayer perceptrons
========================================================

![multilayer network](MLP.PNG)

-made up of sigmoid neurons  
-hidden layer: not input not output  
-we have discussed *feedforward* neural networks (no loops)  

http://neuralnetworksanddeeplearning.com/chap1.html

Neural Networks- handwriting example
========================================================

![](handwriting1.PNG)



Neural Networks- handwriting example cont
========================================================

-inputs: handwritten digit, each input $(x)$ is a 28x28 vector (vector in pixels)  
-desired/ true outputs: 10 dim vector, ie 6 is  $y(x) = (0,0,0,0,0,0,1,0,0,0)^T$  
-use *cost function*:  $C(w,b) \equiv \frac{1}{2n} \sum \limits_{x} || y(x) -a ||^2$  
$w$ weights; $b$ biases; $n$ # training inputs; $a$ predicted outputs  
-want to minimize cost
http://neuralnetworksanddeeplearning.com/chap1.html


Neural Networks- gradient descent algorithm
========================================================

-to determine how to minimize the cost function, use *gradient descent algorithm*  
-say we want to minimize C(v), cost as a function of v  
$\Delta C \approx \nabla C \cdot \Delta v$  
$\Delta v = -\eta \nabla C$  
$\Delta C \approx \nabla C \cdot \Delta v = - \eta || \nabla C || ^2$  

where $\eta$ is the learning rate

-this gives a negative $\Delta C$ 
-we move in the direction of the gradient, updating at each step  
-ideally this will bring us to the global minimum of the cost function
http://neuralnetworksanddeeplearning.com/chap1.html


NN- variable selection problems
========================================================

redundancy: 
-increases number of local optima in error function (i.e. local minima in cost function)  
-training slower: harder to map relationship b/w redundant variables and error  

irrelevant variables:  
-add noise  
-could mask important relationships  

dimensionality:
-as dim of model increases linearly, exponential increase in sample size needed   

-many input variable selection algorithms
http://cdn.intechopen.com/pdfs-wm/14882.pdf


Neural Networks- Storms and Buoy Data
========================================================

-remove variables: 
Dew point, tide, visibility, measurement of wave direction, dominant wave pressure (redundant)

-removed rows with NAs  

-normalized the data between 0, 1

-split into 3/4 training, 1/4 test  

Neural Networks- Variables Used
========================================================

- **WD** (wind direction);degrees clockwise from true North
- **WSPD** (wind speed); m/s averaged over 8 minute period
- **GST** (gust); peak 5 or 8 second gust speed in m/s measured during the 8 min period
- **WVHT** (wave height); meters
- **APD** (average wave period); seconds
- **BAR** (sea level pressure); hecto-Pascals (hPa)
- **ATMP** (air temperature); degrees Celsius
- **WTMP** (water temperature); degrees Celsius
- **Wind_WMO** (maximum sustained wind gust); knots


Neural Networks- Storms and Buoy Data
========================================================


```r
# try a neural net with 2 nodes for the one hidden layer
net.storms <- neuralnet(Wind_WMO ~ WD + WSPD + GST + WVHT + APD + BAR + ATMP + WTMP,
                        trainingStorms, hidden = 2)


# calculate test error rate
results <- compute(net.storms, testingStorms[, 1:8])$net.result[,1]

# MSE 
MSE <- sum((testingStorms$Wind_WMO - results)^2)/nrow(testingStorms)
```

MSE = 0.0154  


Neural Networks- Storms and Buoy Data
========================================================

![](NNplot.png)


Neural Networks- Storms and Buoy Data
========================================================

![](NNpredicted.png)



Random Forest- Storms and Buoy Data
========================================================



![plot of chunk unnamed-chunk-4](Math154Presentation-figure/unnamed-chunk-4-1.png) 



Random Forest- Storms and Buoy Data
========================================================


```r
# make model with parameters ntree = 250, mtry = 6
set.seed(47)

storm.model.rf <- randomForest(Wind_WMO ~., data = trainingStorms,
                               mtry = 6, ntree = 250, importance = TRUE)
```

training MSE = 0.0138  
test MSE = 0.0140


Random Forest- Storms and Buoy Data
========================================================

![](variableimportance.png)




Shiny App- Storms and Buoy Data
========================================================


[http://rstudio.campus.pomona.edu:3838/cle02012/StormsAndBuoys/](http://rstudio.campus.pomona.edu:3838/cle02012/StormsAndBuoys/)

![](shinyStorms.PNG)

Conclusions
========================================================

-variables given do not seem to give enough info to predict Wind_WMO well  
-potential redundancy in variables, problem for NN
