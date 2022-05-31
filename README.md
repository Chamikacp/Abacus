# Abacus
A financial app for the iPhone

The app shall have the ability to solve for one unknown from the given parameters below:

  - t ± time in years (synonymous with number of payments)
  
  - r (%) ± interest rate ± for simple savings only1
  
  - P ± present value
  
  - PMT ± Payment
  
  - A ± future value
  
  - PayPY ± number of payments per year (always assumed to be 12)
  
  - CpY ± number of compound payments per year (always assumed to be 12)
  
  - PmtAt ± payment due at the beginning or end of each period (assumed to be END)
  

The app shall split typical financial problems up over typically four views:

  1) Compound Interest savings (fixed sum investment with no further payments)
  2) Savings ± compound interest with regular contributions (this is savings where 
  there might be sum invested with a subsequent further monthly contribution
  3) Loans/Mortgage - compound interest with regular payments


In addition to this the software shall contain a help view that will contain instructions
and guidance to the user on how to use the software. You have complete freedom on 
how to implement this view and this can be done as separate view or modal context 
views for example, e.g. a pop- overview activated by a help button.

# User Requirements

  R1 The software shall allow the user to estimate interest rate based on other financial 
  data given above.
  
  R2 The software shall allow the user to estimate final value based on other financial 
  data given above.
  
  R3 The software shall allow the user to estimate present value based on other 
  financial data given above. 
  
  R4 The software shall allow the user to estimate the payment based on other financial 
  data given above.
  
  R5 The software shall allow the user to estimate number of payments2 based on 
  other financial data given above. 
  
  R6 The software shall persistently save all user data.
  
  R7 The software shall provide a help view.
  
  R8 The software shall allow the user to switch between number of payments and 
  years4.
  

# System Requirements

  SR1: When sufficient data is entered in any one view that software shall 
       populate the empty field.
  
  SR2: The system shall persist user data if the application close or quits.
  
  SR3: The system shall repopulate fields with any saved user data on app 
       start-up.


![Demo](https://user-images.githubusercontent.com/58659306/171079884-c8ac0872-2ea2-4b31-a7a7-4588d8dd9d5c.gif)




