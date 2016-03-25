# SFDC Required Fields Inspector

A Single Page App that lets you to determine the **Universally Required** fields on multiple objects at once.

<a href="https://githubsfdeploy.herokuapp.com?owner=Deepak-K-Anand&repo=SFDC-Required-Fields-Inspector">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

### Inspiration
Recently one of my close friend in the name *Mayank S.* wanted to know the different Required Fields on an object within Salesforce swiftly without going through the hassles of clicking each field one by one to know it.

The immediate step was to Google it and he was lucky enough to find a snippet from Stack Exchange that did it. One has to open the **Developer Console** and use the **Execute Anonymous** window to execute the script and would need to rely on the Debug Statements to know the fields all at once.

This was a little tedious and since the need came in quite often, he had to find another way out! That is when he discussed the same with me and we thought we can setup a **Visualforce Page** that would let users to find the Required Fields on multiple objects at the same time.

### Technologies Used
1.  Front End
    * Angular JS
    * Bootstrap
2.  Back End
    * Force.com AJAX Toolkit

Note: We can certainly use an Apex Controller and use `Schema.Describe` calls to avoid the Force.com AJAX Toolkit. 

### Usage
You can use the blue **Deploy to Salesforce** button at the top to deploy it directly to your Salesforce instance. When deployed successfully, you should be able too see a *Tab* called **Required Fields Inspector** provided you have assigned permissions to yourself.

![screenshot_2](https://cloud.githubusercontent.com/assets/3683725/14049740/345fa41a-f2dd-11e5-9243-0034689050a0.png)

You can select the object(s) and then hit the **Get Required Fields** button to find out all the required fields.

### Licensing
Completely free! Use it at your own will.

### Credits
Deepak @ [**Dazeworks Technologies Pvt Ltd**](http://dazeworks.com/)
