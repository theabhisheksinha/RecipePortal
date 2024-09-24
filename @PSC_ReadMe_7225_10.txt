Title: XD Portal V 1.1
Description: XD Portal is an open source ASP.NET 2.0 n-tier web application written in C# and SQL stored procedure. XD Portal provides content management capabilities and administration tools to create a dynamic interactive database driven web sites such as community portal, intranet and other Internet portal application. This application is extendable and code is included in the download so you can play around.
Demo URL: http://www.ex-designz.net/xdportalscnshots/xdportal.htm
XD Portal Architecture: DAL &gt; Model &gt; BLL &gt; UI
Features:
1) Secured user login system
2) Admin Manager Page to manage site configuration, contents and users, i.e. suspend user.
3) Comment System
4) Rating System 5) Enabled/disabled comment through admin page.
5) Send to a friend email in HTML format.
6) User Registration photo upload
8) CSS layout interface.
9) Dynamic Layout swithcer i.e. Rows, Grid 2 Columns or Grid 3 Columns
10) Optimized for SE
11) Article/Blog Manager - Add, edit and delete article/blog
Fixed corrupted database header.
Reupload new zip included the XDPortal.Bak
Below is the instructions restoring the backup from the app_data.
1) Open your SQL Management Studio. Create a new Database name &#8220;XDPortal&#8221;.
2) Right click on the database and click restore database.
3) Once the restore window is open. Navigate to the backup sql which is inside the app_data folder. Check the database to restore and click the option in the left panel. This will open another window. There, select overwrite database.
I restore the backup in my Laptop in 1 min. It should be easy.
Download XDPortal, included the XDPortal.Bak
Check MSDN for complete tutorial:
http://msdn.microsoft.com/en-us/library/ms177429.aspx
Added AJAX multi-view event calendar. Calendar screenshots:
http://www.ex-designz.net/xdportalscnshots/eventsmainpage.gif
http://www.ex-designz.net/xdportalscnshots/eventlistview.gif
http://www.ex-designz.net/xdportalscnshots/eventweekview.gif
Update: 5-10-09: Re-write some long stored procedures so it will be easy to read, understand and maintained. Added repeater multiple/batch delete of rows through a comma separated value so it only hits the database once, instead of looping.
This file came from Planet-Source-Code.com...the home millions of lines of source code
You can view comments on this code/and or vote on it at: http://www.Planet-Source-Code.com/vb/scripts/ShowCode.asp?txtCodeId=7225&lngWId=10

The author may have retained certain copyrights to this code...please observe their request and the law by reviewing all copyright conditions at the above URL.
