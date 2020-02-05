Workshop 2\_Nonlinear Models
================
Steven Unger
2/5/2020

# Objectives

The primary objectives of this analysis are to fit monthly light
response curves for Harvard forest to understand annual patterns of
ecosystem photosynthetic potential and respiration rates in temperate
mixed forests. We will learn how to apply non-linear models and
bootstrapping in R so that if need be, we can apply this technique to
our own datasets further own the line.

# Methods

## Site Information

An eddy covariance tower located above the canopy in Harvard forest in
Massachusetts was used to collect continuous data of various ecological
parameters such as PAR, Temperature, precipitation, and gas exchange
(GPP, R, etc). The site contains various dominant species; red oak, red
maple, black birch, white pine, and eastern hemlock. For information
about sensors and background info for the EMS tower at Harvard Forest,
Visit [Flux at Harvard
Forest](https://harvardforest.fas.harvard.edu/other-tags/eddy-flux)

## Photosynthetic Potential

Photosynthetic potential is the plants maximum capacity to
photosynthesize. As shown below in figure 1, the light response curve is
not a linear regression. At low light levels, photosynthesis cannot
reach peak rates (light limited). At higher light levels, we reach peak
photosynthetic rate. At light levels higher than that, we are limited by
the carbon fixation of rubisco enzymes, not light, and we actually
observe photorespiration ( a decline in net photosynthesis because the
plant starts to respire more (Arulanantham *et al*, 1990) (Smith, 1938),
(Taylor and Terry, 1984).

![Figure 1: General Light repsponse
curve](/Users/Lee/Desktop/QEco/NLM%20workshop/light%20curve.png)

## Ecosystem Respiration

Ecosystem respiration is the gross sum of all respiration (CO2
production) in an environment and is one of the main determinants of the
carbon balance (valentini *et al* 2000). Respiration is heavily
dependent on temperature and moisture (Flanagan and Johnson, 2005).
Understanding this term (R eco) allows us to calculate and correct other
ecological parameters such as GPP & NEP to see what the net exchange of
carbon is (NEE) which is crucial to building carbon budgets.

![Figure 2: Ecosystem Respiration modelled after the Arrhenius
approach](/Users/Lee/Desktop/QEco/NLM%20workshop/Reco.png)

# Results

Figure 3 shows the light response curve (NEE vs PAR) decreasing in NEE
the closer to 0 PAR is. This is telling us that the system is acting
more like a CO2 sink at low light levels than at high light levels.
Table 1 shows the various parameter values over the 12 month period to
be used to start the initial nls with bootstrap and also gives p-values
for each months
parameters.

| MONTH |         a1 |         ax |          r | a1.pvalue | ax.pvalue | r.pvalue | X  |
| ----: | ---------: | ---------: | ---------: | --------: | --------: | -------: | :- |
|     1 | \-4.08e-05 |   4.46e-03 |   1.470930 |  3.31e-02 |    0.0333 | 0.000000 | NA |
|     2 |   8.35e-03 |   1.01e+00 |   1.253452 |  3.30e-02 |    0.0000 | 0.000000 | NA |
|     3 |   7.59e-04 |   9.94e-02 |   1.296303 |  7.84e-01 |    0.3520 | 0.000000 | NA |
|     4 | \-3.79e+00 |   1.01e+00 | \-0.457579 |  0.00e+00 |    0.0000 | 0.000443 | NA |
|     5 | \-1.72e-01 | \-8.11e+00 |   3.687535 |  0.00e+00 |    0.0000 | 0.000000 | NA |
|     6 | \-8.25e-01 | \-2.75e+01 |   5.855905 |  0.00e+00 |    0.0000 | 0.000000 | NA |
|     7 | \-8.73e-01 | \-3.17e+01 |   6.155766 |  0.00e+00 |    0.0000 | 0.000000 | NA |
|     8 | \-7.11e-01 | \-3.11e+01 |   5.739692 |  0.00e+00 |    0.0000 | 0.000000 | NA |
|     9 | \-8.03e-01 | \-2.51e+01 |   4.880482 |  0.00e+00 |    0.0000 | 0.000000 | NA |
|    10 | \-5.00e-01 | \-7.92e+00 |   3.146178 |  0.00e+00 |    0.0000 | 0.000000 | NA |
|    11 | \-1.64e-02 | \-1.99e+00 |   2.119615 |  2.00e-07 |    0.0000 | 0.000000 | NA |
|    12 | \-2.96e-05 |   6.28e-04 |   1.647433 |  9.09e-01 |    0.9090 | 0.000000 | NA |

**Table 1: a1, ax, r parameters, and Bootstrap p-values **

![Figure 3: Light response curve, NEE vs
PAR](/Users/Lee/Desktop/QEco/NLM%20workshop/Rplot.png)

# Discussion

The purpose of this workshop was to understand annual patterns of
ecosystem photosynthetic potential and respiration rates by fitting
monthly light response curves to Harvard forest flux data. Our goal was
to adjust the model parameters so that we could find the curve that best
fits our data. Three main assumptions must be made about the error term;
they are normally distributed, homogeneous, and independent. After
confirming these assumptions, we ran multiple simulations after
selecting initial values and then bootstrapped, to get better initial
values with error estimates, and allowed the simulation to ran many
times. It is interesting that at lower light levels (PAR), NEE was
actually more negative, which suggests that the habitat was storing more
carbon. This does not make intuitive sense, at least at the light levels
here (PAR\<1000) because you would expect that they are taking in more
carbon at lower light levels than they respire since they are not carbon
limited. In otherwords, they should be able to use all of the light at
that range to photosynthesize ans take in carbon, but the data shows,
they are actually respiring at low light levels then at high light
levels.

## Works Cited

Arulanantham, A. R., Rao, I. M., & Terry, N. (1990). Limiting factors in
photosynthesis: VI. Regeneration of ribulose 1, 5-bisphosphate limits
photosynthesis at low photochemical capacity. Plant physiology, 93(4),
1466-1475.

Flanagan, L. B., & Johnson, B. G. (2005). Interacting effects of
temperature, soil moisture and plant biomass production on ecosystem
respiration in a northern temperate grassland. Agricultural and Forest
Meteorology, 130(3-4), 237-253.

Smith, E. L. (1938). Limiting factors in photosynthesis: light and
carbon dioxide. The Journal of general physiology, 22(1), 21-35.

Taylor, S. E., & Terry, N. (1984). Limiting factors in photosynthesis:
V. Photochemical energy supply colimits photosynthesis at low values of
intercellular CO2 concentration. Plant Physiology, 75(1), 82-86.

Valentini, R., Matteucci, G., Dolman, A. J., Schulze, E. D., Rebmann, C.
J. M. E. A. G., Moors, E. J., … & Lindroth, A. (2000). Respiration as
the main determinant of carbon balance in European forests. Nature,
404(6780), 861-865.
