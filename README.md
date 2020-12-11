# CEU-Data_Engineering2
### by Viktória Mészáros, Brúnó Helmeczy and Attila Serfőző

# Content of the repository
* [Report describing the project](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/blob/main/DE2_Report_Text.docx)
* [PPT of the project](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/blob/main/DE2_TermProject_VM_BH_AS.pptx)
* [Knime Workflow](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/blob/main/VM_BH_AS_Term_project.knwf) 
* [Code folder](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/tree/main/Code) - containing an SQL script for creating our Eurostat database and an R script dowloading WDI data
* [Data folder](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/tree/main/Data) - in which you can find a table of [country_codes](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/blob/main/Data/country_codes.csv) which we used as a linktable and a [Raw_text_files folder](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/tree/main/Data/Raw_Text_files) having all the input files for the Knime workflow
* [Out folder](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/tree/main/Out) - which has all the graphs we created for our analysis



# Workflow Reproducability
We made our project reproducable with only slight modifications.
*Steps you need to do:*
1. Open the Knime Workflow and 1st run the File Reader section (it saves the required files to your MySQL upload folder, if the path we included does not work, please change it to your folder 
2. Open MySQL on your computer and run the provided Load_Data.sql script
3. Configure the MySQL Connector node in Knime, i.e. set your own username & password
4. Make sure you have R installed on your PC, have the Rserve package installed in it & set your R root folder location in KNIME (File>Preferences>KNIME>R>Path to R home)
5. If you want to save the output images change the "Output Location" for all the "Input Nodes". We saved all the outputs [here](https://github.com/Viki-Meszaros/CEU-Data_Engineering2/tree/main/Out) for your convenience
6. Run the workflow
