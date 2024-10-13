<cfscript>
  
  public string function getfileType(required string ext)	{

    rt = "fal fa-file-alt"
    switch(left(ListLast(arguments.ext,'.'),3))	{
      case "pdf": 
        rt = "fal fa-file-pdf text-danger"
      break;
      case "csv": 
      case "xls": 
      case "xlsx": 
        rt = "fal fa-file-excel text-success"
      break;
      case "doc": 
      case "docx": 
        rt = "fal fa-file-word text-secondary"
      break;
      case "ppt": 
      case "pptx": 
        rt = "fal fa-file-powerpoint text-warning"
      break;
      case "jpg": 
      case "jpe": 
      case "png": 
      case "gif": 
      case "bmp": 
        rt = "fal fa-file-image text-warning"
      break;
    }

    return rt
  }

</cfscript>