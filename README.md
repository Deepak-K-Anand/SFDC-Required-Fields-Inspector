# SFDC Required Fields Inspector

A Single Page App that lets you to determine the **Universally Required** fields as well as the fields marked required on the **Page Layout** on different objects.

<a href="https://githubsfdeploy.herokuapp.com?owner=Deepak-K-Anand&repo=SFDC-Required-Fields-Inspector">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

### Inspiration
Recently one of my close friends in the name [*Mayank S.*](https://twitter.com/sriv_mayank) wanted to know the different Required Fields on an object within Salesforce swiftly without going through the hassles of clicking each field one by one to know it.

The immediate step was to Google it and he was lucky enough to find a snippet from Stack Exchange that did it. One has to open the **Developer Console** and use the **Execute Anonymous** window to execute the script and would need to rely on the Debug Statements to know the fields all at once.

This was a little tedious and since the need came in quite often, he had to find another way out! That is when he discussed the same with me and we thought we can setup a **Visualforce Page** that would let users to find the Required Fields(both *Universally Required* as well as those marked required on *Page Layout*) on different objects.

### Technologies Used
1.  Front End
    * Angular JS
    * Bootstrap
2.  Back End
    * Force.com AJAX Toolkit

Note: We can certainly use an Apex Controller and use `Schema.Describe` calls to avoid the Force.com AJAX Toolkit. 

### Usage
You can use the blue **Deploy to Salesforce** button at the top to deploy it directly to your Salesforce instance. When deployed successfully, you should be able too see a *Tab* called **Required Fields Inspector** provided you have assigned permissions to yourself.

![Required Fields Inspector](https://cloud.githubusercontent.com/assets/3683725/14409389/954e450c-ff2f-11e5-9790-dfb8b33c7d1e.png)

You can select the object and then hit the **Get Required Fields** button to find out all the required fields.

### Licensing
Completely free! Use it at your own will.

### Credits
Deepak @ [**Dazeworks Technologies Pvt Ltd**](http://dazeworks.com/)
