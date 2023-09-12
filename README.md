# MBG351 Research Project Lecture

By İrem Kahveci<sup>1</sup>


<sup>1</sup> Abdullah Gül University, Molecular Biology and Genetics, Kayseri – TURKEY
- Email: irem.kahveci@agu.edu.tr
  
## Research Proposal Guideline

### I. Project Title
C. elegans Atlas

### II. Research Proposal Abstract
The use of C. elegans as a model organism in human-oriented studies is of great importance. Caenorhabditis elegans is a useful model organism for studying a variety of diseases ranging from SMA disease to mitochondrial diseases. It contributes to science in the analysis of data obtained in image processing research. R Shiny package, which is a kind of open software and increasingly used in data science, is a powerful tool that enables to create interactive web applications directly from R with results in various research fields such as genetics, engineering, bioinformatics. In this study, the main goal is to create an open-source website for the C. elegans images obtained with a confocal microscope and the C. elegans anatomy manually drawn in R Shiny well-done application.

### III. Introduction and Literature Review
Studies have shown that decoding the human body at the molecular level will greatly increase the existing knowledge about human biology and diseases[1].

The continued discovery of rare diseases and their genetic underpinnings provides more than 200 million affected patients worldwide and supports research and better understanding of disease mechanisms [2, 3]. Human genetic studies with a model organism provide detailed biological information in preventing difficulties caused by undiagnosed diseases, discovering disease-gene relationships, creating variant analyzes, and understanding gene location analyzes[4]. In addition, C.elegans is the mostly preferred model organism in many research branches, especially in neurobiology and genetics. [7]. Although it has criteria such as similarity or equality between human-gene in the selection of model organisms in line with the determined purposes, it has practical and ethical limitations to carry out studies. [4-5]. Various approaches have been adopted in the search for human disease genes. [5]. While balancing the understanding and explanation of various aspects of human disease, studies using C. elegans, a type of nematode, for the identification of human disease genes offer a cell biological, genetic, and genomic tool, particularly disease gene discovery. In addition, compared to other mammalian model organisms (such as the mouse), C. elegans accurately mimics human diseases and has a quick response time to genetic changes. Cell line studies, for instance, are effective in identifying signaling pathways, have wide possibilities for general organismal physiology, and are frequently found in cell culture thanks to the development of tools like RNA interference (RNAi) and CRISPR/Cas9 genome editing, as well as more traditional biochemical techniques. [5].

According to studies, 2/3 of the genes causing human diseases are homologous in the C. elegans genome[6]. Due to its ability to be genetically modified, stable and well-defined developmental program, characterized genome, ease of maintenance, brief and fruitful life cycle, and small size, C. elegans is frequently chosen as a model organism. [7]. 

It is crucial that studies focused on people use C. elegans as a model organism [4,6,7]. The Human Protein Atlas Project was established to map all human proteins in cells, tissues, and organs in the human body using mass spectrometry-based proteomic, transcriptomics, systems biology, and antibody-based imaging. The project was inspired by the planning of the study (C.elegans Atlas). In a similar vein, the C. elegans Atlas project seeks to provide regional (lung, for example), human-gene pairings using the anatomy of the C. elegans, as well as the image and cilia movements of the C. elegans IFT encoded genes [2]. Using C.elegans Atlas confocal-based imaging and R programming, and in the future, using the integration of various technologies such as proteomic and transcriptomics, the open-source 3D anatomy of C. elegans, as well as cilia movements, and human C.elegans common genes through R Shiny. and web-based project. In line with this project, 3D C.elegans drawings were made in the first place.

### IV. Aim of the Work
C.elegans Atlas is an open source-based project that aims to show the 3D anatomy of C. elegans, along with cilia movements, genes in comparison with equivalent variants in humans and C. elegans, using R Shiny, basically using confocal-based imaging and R programming.

### V. Material and Methods

1. **C. Elegans Drawing Process:**
   For anatomy presented in C. elegans Atlas, C.elegans anatomy was used using 3D Studio Max(V2021.04) with reference to WormBook[10] and wormatlas.org[11] and exported in .obj format.
   
   ![Figure-1: C. elegans Anatomy Design Process via 3D Cinema Max](link-to-image1)

2. **Web App Design Process:**
   R Studio(V4.1.1) was used to create the C. elegans Atlas infrastructure, R Shiny(V1.7.1) was used to create the website, rgl (V0.109) packages were used to visualize the C. elegans anatomy in the manually drawn .obj format and to make the image compatible with the web. Additionally, shinythemes(V1.2.0), shinyWidgets(V0.7.0), shinydashboard(V0.7.2), png(V0.1.7) were used for website interface design and image manipulation. Shinyrgl(V0.1.0) was used to solve the shiny and rgl integration.

   ![Figure 2: C.elegans Atlas Main Shiny Web Page](link-to-image2)

   ![Figure 3: C.elegans 3D Structure in Web](link-to-image3)

3. **Web Publish Process:**
   Shineapps.io infrastructure was preferred for the release of Shiny App written in R Studio (V4.1.1). When the system becomes more comprehensive after the problems are resolved, different infrastructure systems may be preferred.

### VI. Conclusion (10 pts)
C. elegans Atlas, interactive - 3D A tool for simultaneous visualization of human-C.elegans common genes, visualization of cilia movements, together with C. elegans anatomy.
In addition, since the C. elegans atlas project is a web-based software, it does not require installation in application form. By uploading their own samples to the system, researchers can compare them with existing samples (confocal images, gene-location matches) in the current system. And you can export it in any format you want. (.png, .jpg, .obj). One of the other important features of C. elegans Atlas is that it provides quick solutions to researchers and ease of use.

### VII. Bibliography
1. Uhlen, M., Fagerberg, L., Hallstrom, B.M, Lindskog, C. et all. (2015). Tissue-based map of the human proteome. Science. Vol. 347, No. 6220.
2. Uhlen, M, Björling, E., Agaton, C., et all. (2005). A Human Protein Atlas for Normal and Cancer Tissues Based on Antibody Proteomics. Molecular & Cellular Proteomics. Volume 4, Issue 12. P 1920-1932.
3. Wangler, M.F., Yamamoto, S., Chao, H.T., et all. (2017). Model Organisms Facilitate Rare Disease Diagnosis and Therapeutic Research. Genetics. 207(1), P 9-27.
4. Baldridge, D., Wangler, M.F., Bowman, A.N., Yamamoto, S., et all. (2021). Model organisms contribute to diagnosis and discovery in the undiagnosed diseases network: current state and a future vision. Orphanet Journal of Rare Diseases. 16, 206.
5. Apfeld, J., Alper, S. (2019). What Can We Learn About human Disease from the Nematode C.elegans? Methods Mol Biol. 1706: P 53-75.
6. Zhang, S., Li, F., Zhou, T., Wang, G., Li, Z. (2020). Caenorhabditis elegans are a useful Model for Studying Aging Mutations. Frontiers in Endocrinology. Volume 11.
7. Leung, M.C.K, Williams, P.L., Benedetto, A., Au, C., et all. (2008). Caenorhabditis elegans: An Emerging Model in Biomedical and Environmental Toxicology. Toxicol Science. 106(1): P 5-28.
8. Ponten, F., Jirström, K., Uhlen, M. (2008). The Human Protein Atlas – a tool for pathology. The Journal of pathology. 216(4), P 387-393.
9. Thul, P.J., Lindskog, C. (2018). The human protein atlas: A spatial map of the human proteome. The Protein Society. 27(1): P 233-244.
10. Corsi, A.K., Wightman, B., Chalfie, M. (2015). A Transparent window into biology: A primer on Carnorhabditis elegans. WormBook: The Online Review of C. elegans Biology.
11. WormAtlas, Altun, Z.F., Herndon, L.A., Wolkow, C.A., Crocker, C., Lints, R. and Hall, D.H. (ed.s) 2002-2023. [http://www.wormatlas.org](http://www.wormatlas.org)
