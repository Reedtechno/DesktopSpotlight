# DesktopSpotlight
Powershell script to use Microsoft Spotlight images(From Lockscreen) for your desktop background.

Run script daily (recommend task scheduler) to retrieve images from the Spotlight temp folder and save a folder of your choosing.

By default, images will be saved to <code>C:\temp\SpotLight</code>.

You must manually set your background to slideshow and set the path to <code>C:\temp\SpotLight</code> or the path you set using <code>-IMGstore</code> param.

Credit to The Scripting Guy for the <code>Get-FileMetaDataReturnObject</code> function. (https://gallery.technet.microsoft.com/scriptcenter/get-file-meta-data-function-f9e8d804#content)
