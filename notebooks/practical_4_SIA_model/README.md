# Practical 4: ice sheet modelling

This directory contains notebooks written to solve the ice sheet model equations derived in lectures 6 and 7. 

## The model

$$
\frac{\partial H}{\partial t} = \dot{b_i}(x) - \frac{\partial q}{\partial x},
$$

$$
q = -\frac{2A}{n+2} \left(\rho g \alpha \right)^n  H^{n+2}  
$$

where $\dot{b_i}$ is the ice-equivalent rate of accumulation on the ice sheet surface, $x$ is the horizontal coordinate, $H$ is the ice thickness, $t$ is time, $q$ is the depth-intergrated flux per unit width (hereafter, flux), $A$ is the flow parameter from the flow law, $n$ is the exponent from the flow law, $\rho$ is the density of ice, $g$ is acceleration due to gravity, and $\alpha$ is the surface slope $\left(= - \frac{\partial H}{\partial x}\right)$.

## The incomplete notebooks

There are three different levels of notebook. Select the level you feel comfortable with based on the descriptions below. 

**Be ambitous! You can always look at the other notebooks if you get stuck!**

### Level 1: A working code with a few crucial lines removed.
This version of the notebook has a few lines missing that you will need to write in order to get the model running and plot the results. 

### Level 2: A working code with a many lines removed.
This version of the notebook has a many lines missing that you will need to write in order to get the model running and plot the results.  

### Level 3: The structure of a working code, with all the code removed. 
This version of the notebook contains all the text cells and headings, but none of the actual code. You will need to add one or many lines of code to every empty cell in this notebook. 

### Level 4: start with a blank notebook
Start from scratch with a blank notebook and write all you own notes and code. 

## The complete code

P4_full.ipynb is the complete version of this notebook containing working code to solve the model..
