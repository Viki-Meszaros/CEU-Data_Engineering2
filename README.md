# CEU-Data_Engineering2
### by Viktória Mészáros, Brúnó Helmeczy and Attila Serfőző

This project was created for fulfilling term-project requirements for the Data Engineering 2: Different Shapes of Data course of Central European University’s MSc in Business Analytics program. 

# Content of the repository
* [Report of the project](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/blob/main/VM_BH_AS_Report.pdf)
* [PPT](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/blob/main/VM_BH_AS_presentation.pptx)
* [Knime Workflow](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/blob/main/VM_BH_AS_Workflow.knwf) 
* [Code folder](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/tree/main/Code) - containing an SQL script for creating our Eurostat database and an R script dowloading WDI data
* [Data folder](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/tree/main/Data) - in which you can find a table of [country_codes](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/blob/main/Data/country_codes.csv) which we used as a linktable and a [Raw_text_files folder](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/tree/main/Data/Raw_Text_files) having all the input files for the Knime workflow
* [Out folder](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/tree/main/Out) - which has all the graphs we created for our analysis



# Reproducability of the workflow
We made our project reproducable with only slightly modifications.

*Steps you need to do:*
1. Open the Knime Workflow and run the File Reader section (it saves the required files to your MySQL upload folder, if the path we included does not work, please change it to your folder 
2. Open MySQL on your computer and run the provided Load_Data.sql script
3. Configure the MySQL Connector node in Knime, set up your username & password
4. Make sure that you have R installed on your computer, have Rserve package installed in it and set your R root folder location in KNIME (File>Preferences>KNIME>R>Path to R home)
5. If you want to save the output images change the "Output Location" for all the "Input Nodes", but we also saved all the outputs [here](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/tree/main/Out).
6. You are done, now run the workflow

The overview of our workflow is the following:
https://github.com/Viki-Meszaros/CEU-Data_Engineering2/blob/main/Project_Flowchart.jpg

For further details prease read our [report](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/blob/main/VM_BH_AS_Report.pdf).
