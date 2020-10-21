#tag Class
Protected Class DatePicker
Inherits WebControlWrapper
	#tag Event
		Function ExecuteEvent(Name as String, Parameters() as Variant) As Boolean
		  //Dispatch events from the end user's browser here
		  If Self.Enabled Then
		    Select Case Name
		      
		    Case "Click"
		      Dim d As new date
		      d.SQLDate = Parameters(0)
		      d.Hour = 0
		      d.Minute = 0
		      d.Second = 0
		      
		      DisplayDate = New Date(D)
		      
		      mSelectedDate = New Date(DisplayDate)
		      
		      Redisplay()
		      
		      RaiseEvent DateSelected(D)
		      
		      
		      
		      Return True
		      
		    Case "ChangeMonth"
		      DisplayDate.Day = 1
		      
		      If Parameters(0)<0 then
		        DisplayDate.Month = DisplayDate.Month -1
		      Else
		        DisplayDate.Month = DisplayDate.Month+1
		      End If
		      mFirstDate = Nil
		      
		      ViewChanged()
		      
		      Redisplay()
		    End Select
		  End If
		  
		  Return False
		End Function
	#tag EndEvent

	#tag Event
		Sub FrameworkPropertyChanged(Name as String, Value as Variant)
		  //Only send changes to the browser if the Shown event has fired. Otherwise, they should be rendered in the InitialHTML event.
		  If ControlAvailableInBrowser Then
		    Select Case Name
		    Case "Enabled"
		      Dim js As String
		      If value Then
		        js = "Xojo.get('" + Me.ControlID + "').style.opacity = 1; Xojo.get('" + Me.ControlID + "').style.cursor = 'auto';"
		      Else
		        js = "Xojo.get('" + Me.ControlID + "').style.opacity = 0.5; Xojo.get('" + Me.ControlID + "').style.cursor = 'default';"
		      End If
		      ExecuteJavaScript(js)
		      
		    Case "Visible"
		      Dim js As String
		      If value then
		        js = "Xojo.get('" + Me.ControlID + "').style.visibility = ""visible"";"
		      Else
		        js = "Xojo.get('" + Me.ControlID + "').style.visibility = ""hidden"";"
		      End If
		      ExecuteJavaScript(js)
		      
		    End Select
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  
		  //Do something here
		  
		  
		  DisplayDate = New Date
		  
		  
		  //Month Names
		  SetupLocaleInfo()
		  
		  
		  me.FirstDayOfWeek = 2
		  
		  DateStyle = New Dictionary
		  
		  
		  Open()
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Resized()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Sub SetupCSS(ByRef Styles() as WebControlCSS)
		  styles(0).value("visibility") = "visible" // Every WebSDK control needs this
		  
		  Dim st As WebControlCSS
		  
		  st = new WebControlCSS
		  st.Selector = "." + self.ControlID + "_dp-cell"
		  st.Value("text-align") = "center"
		  st.Value("padding") = "2px"
		  Styles.Append st
		  
		  st = new WebControlCSS
		  st.Selector = "." + self.ControlID + "_dp-day:hover"
		  st.Value("background-color") = "#EEE"
		  Styles.Append st
		  
		  st = new WebControlCSS
		  st.Selector = "." + self.ControlID + "_dp-onmonth"
		  st.Value("color") = "#222"
		  Styles.Append st
		  
		  st = new WebControlCSS
		  st.Selector = "." + self.ControlID + "_dp-offmonth"
		  st.Value("color") = "#999"
		  Styles.Append st
		  
		  
		  st = new WebControlCSS
		  st.Selector = "." + self.ControlID + "_dp_title"
		  st.Value("cursor") = "default"
		  Styles.Append st
		  
		  st = new WebControlCSS
		  st.Selector = "." + self.ControlID + "_dp_change"
		  st.Value("cursor") = "pointer"
		  Styles.Append st
		End Sub
	#tag EndEvent

	#tag Event
		Function SetupHTML() As String
		  Dim sty As String = ""
		  Dim cla As String
		  
		  If Not Self.Enabled Then
		    sty = " style=""opacity:0.5;cursor:default; height: auto !important;"""
		  else
		    sty = " style=""height: auto !important;"""
		  End If
		  
		  If ShowStyleProperty and Style <> Nil then
		    cla = " class=""" + Style.Name + """"
		  End If
		  
		  
		  
		  Return "<div id=""" + self.ControlID + """" + sty + cla + ">"  + GetHTML + "</div>"
		End Function
	#tag EndEvent

	#tag Event
		Function SetupJavascriptFramework() As String
		  //
		End Function
	#tag EndEvent


	#tag Method, Flags = &h1
		Protected Function GetHTML() As String
		  Dim Data() As String
		  Dim text, cla, claArr() As String
		  Dim DrawDate, Today As Date
		  Dim i, u As Integer
		  Dim onClick As String = " onclick=""Xojo.triggerServerEvent('" + Self.ControlID + "','Click',['%date%']); return false;"" "
		  
		  Dim onClick2 As String = "onclick=""Xojo.triggerServerEvent('" + Self.ControlID + "','ChangeMonth',['%value%']); return false;"" "
		  
		  //Setting FirstDate
		  DrawDate = New Date(FirstDate)
		  Today = New Date
		  
		  //Month Title
		  text = MonthNames(DisplayDate.Month) + " " + str(DisplayDate.Year)
		  Data.Append "<table cellspacing=""0"" cellpadding=""0"" style=""width:100%;-moz-user-select:none;-webkit-user-select:none;"">"
		  Data.Append "<tbody>"
		  Data.Append "<tr>"
		  cla = " class=""cSt_dp_cell cSt_dp_title " + self.ControlID +"_dp_title """
		  If YearSelector then
		    text = MonthNames(DisplayDate.Month)
		    Data.Append "<td " + cla + onClick2.Replace("%value%", "-1") + "><</td>"
		    Data.Append "<td " + cla + " colspan=""2"">" + text + "</td>"
		    Data.Append "<td " + cla + onClick2.Replace("%value%", "1") + ">></td>"
		    text = str(DrawDate.Year)
		    Data.Append "<td " + cla + onClick2.Replace("%value%", "-12") + "><</td>"
		    Data.Append "<td " + cla + ">" + text + "</td>"
		    Data.Append "<td " + cla + onClick2.Replace("%value%", "12") + ">></td>"
		  Else
		    text = MonthNames(DisplayDate.Month) + " " + str(DisplayDate.Year)
		    Data.Append "<td " + cla.Replace(" """, " " + self.ControlID + "_dp_change""") + onClick2.Replace("%value%", "-1") + ">◀</td>"
		    Data.Append "<td " + cla + " colspan=""5"">" + text + "</td>"
		    Data.Append "<td " + cla.Replace(" """, " " + self.ControlID + "_dp_change""") + onClick2.Replace("%value%", "1") + ">▶</td>"
		  End If
		  Data.Append "</tr></tbody></table>"
		  
		  //Drawing DayNames
		  Data.Append "<table cellspacing=""0"" cellpadding=""0"" style=""width:100%;-moz-user-select:none;-webkit-user-select:none;"">"
		  Data.Append "<tbody>"
		  Data.Append "<tr>"
		  
		  cla = " class=""cSt_dp_cell cSt_dp_dayName " + self.ControlID +"_dp_title"""
		  
		  For i = 0 to 6
		    If (FirstDayOfWeek + i) = 7 then
		      text = TitleCase(DayNames(7))
		    else
		      text = TitleCase(DayNames((FirstDayOfWeek + i) mod 7))
		    End If
		    
		    Data.Append "<th " + cla + " title=""" + text + """>" + text.Left(1) + "</th>"
		  Next
		  
		  Data.Append "</tr>"
		  //End of DayNames
		  
		  //DayNumbers
		  
		  u = WeeksPerMonth*7
		  For i = 1 to u
		    If i mod 7 = 1 then
		      Data.Append "<tr style=""cursor:pointer"">"
		    End If
		    text = str(DrawDate.Day)
		    
		    ReDim claArr(-1)
		    
		    claArr.Append "cSt_dp_cell"
		    If DrawDate.Month <> DisplayDate.Month then
		      claArr.Append "cSt_dp_offmonth"
		    else
		      claArr.Append "cSt_dp_onmonth"
		    End If
		    If DrawDate.SQLDate = Today.SQLDate Then
		      claArr.Append "cSt_dp_Today"
		    End If
		    If SelectedDate <> Nil and DrawDate.SQLDate = SelectedDate.SQLDate then
		      claArr.Append "cSt_dp_selecteddate"
		    End If
		    
		    claArr.Append "cSt_dp_dayNbr"
		    
		    If i mod 7 = 1 then
		      claArr.Append "cSt_dp_dayLeft"
		    elseif i mod 7 = 0 then
		      claArr.Append "cSt_dp_dayRight"
		    End If
		    
		    If DateStyle <> Nil and DateStyle.HasKey(DrawDate.SQLDate) then
		      Dim v As Variant = DateStyle.Value(DrawDate.SQLDate)
		      If v isa WebStyle then
		        claArr.Append WebStyle(v).Name
		      else
		        claArr.Append v.StringValue
		      End If
		    End If
		    
		    cla = " class=""" + Join(claArr, " ") + """"
		    'If DrawDate.Month <> DisplayDate.month then
		    'cla = " class=""" + self.ControlID + "_dp-cell " + self.ControlID + "_dp-day "+ self.ControlID + "_dp-offmonth """
		    'else
		    'cla = " class=""" + self.ControlID + "_dp-cell " + self.ControlID + "_dp-day "+ self.ControlID + "_dp-onmonth """
		    'End If
		    
		    Data.Append "<td " + cla + onClick.Replace("%date%", DrawDate.SQLDate) + ">" + text + "</td>"
		    
		    If i mod 7 = 0 then
		      Data.Append "</tr>"
		    End If
		    
		    DrawDate.Day = DrawDate.Day+1
		  Next
		  //End of DayNumbers
		  
		  Data.Append "</tbody>"
		  Data.Append "</table>"
		  
		  
		  
		  Return Join(Data, EndOfLine)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetLocaleInfo(type as Integer, mb as MemoryBlock, ByRef retVal as String) As Integer
		  #if TargetWin32
		    
		    Dim LCID As Integer = &H400
		    
		    Soft Declare Function GetLocaleInfoA Lib "kernel32" (Locale As integer, LCType As integer, lpLCData As ptr, cchData As integer) As Integer
		    Soft Declare Function GetLocaleInfoW Lib "kernel32" (Locale As integer, LCType As integer, lpLCData As ptr, cchData As integer) As Integer
		    
		    dim returnValue as Integer
		    dim size as Integer
		    
		    if mb <> nil then size = mb.Size
		    
		    if System.IsFunctionAvailable( "GetLocaleInfoW", "Kernel32" ) then
		      if mb <> nil then
		        returnValue = GetLocaleInfoW( LCID, type, mb, size ) * 2
		        retVal = ReplaceAll( DefineEncoding( mb.StringValue( 0, returnValue ), Encodings.UTF16 ), Chr( 0 ), "" )
		      else
		        returnValue = GetLocaleInfoW( LCID, type, nil, size ) * 2
		      end if
		    else
		      if mb <> nil then
		        returnValue = GetLocaleInfoA( LCID, type, mb, size ) * 2
		        retVal = ReplaceAll( DefineEncoding( mb.StringValue( 0, returnValue ), Encodings.ASCII ), Chr( 0 ), "" )
		      else
		        returnValue = GetLocaleInfoA( LCID, type, nil, size ) * 2
		      end if
		    end if
		    
		    return returnValue
		    
		  #else
		    #Pragma Unused type
		    #Pragma Unused mb
		    #Pragma Unused retVal
		  #endif
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Redisplay()
		  If ControlAvailableInBrowser() Then
		    ExecuteJavaScript("Xojo.get('" + me.ControlID + "').innerHTML = '" + _
		    ReplaceLineEndings(GetHTML.ReplaceAll("'", "\'"), "") + "';")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function Registered() As Boolean
		  Return True
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetupLocaleInfo()
		  #if TargetWin32
		    
		    Dim i, ret As Integer
		    Dim retVal As String
		    Dim mb as new MemoryBlock( 2048 )
		    
		    //Day Names
		    Const LOCALE_SDAYNAME1 = 42'&h0000002A
		    Const LOCALE_SDAYNAME2 = &h0000002B
		    Const LOCALE_SDAYNAME3 = &h0000002C
		    Const LOCALE_SDAYNAME4 = &h0000002D
		    Const LOCALE_SDAYNAME5 = &h0000002E
		    Const LOCALE_SDAYNAME6 = &h0000002F
		    Const LOCALE_SDAYNAME7 = &h00000030
		    dim dayConst( 7 ) as Integer
		    dayConst = Array( LOCALE_SDAYNAME1, LOCALE_SDAYNAME2, LOCALE_SDAYNAME3, _
		    LOCALE_SDAYNAME4, LOCALE_SDAYNAME5, LOCALE_SDAYNAME6, LOCALE_SDAYNAME7 )
		    
		    for i = 0 to 6
		      ret = GetLocaleInfo( dayConst( i ), mb, retVal )
		      DayNames((i+1) mod 7 +1) = Titlecase ( ConvertEncoding(retVal, Encodings.UTF8) )
		    next
		    
		    //Month Names
		    Const LOCALE_SMONTHNAME1 = 56'&h00000038
		    Const LOCALE_SMONTHNAME2 = &h00000039
		    Const LOCALE_SMONTHNAME3 = &h0000003A
		    Const LOCALE_SMONTHNAME4 = &h0000003B
		    Const LOCALE_SMONTHNAME5 = &h0000003C
		    Const LOCALE_SMONTHNAME6 = &h0000003D
		    Const LOCALE_SMONTHNAME7 = &h0000003E
		    Const LOCALE_SMONTHNAME8 = &h0000003F
		    Const LOCALE_SMONTHNAME9 = &h00000040
		    Const LOCALE_SMONTHNAME10 = &h00000041
		    Const LOCALE_SMONTHNAME11 = &h00000042
		    Const LOCALE_SMONTHNAME12 = &h00000043
		    Const LOCALE_SMONTHNAME13 = &h0000100E
		    dim monthConst( 13 ) as Integer
		    monthConst = Array( LOCALE_SMONTHNAME1, LOCALE_SMONTHNAME2, LOCALE_SMONTHNAME3, _
		    LOCALE_SMONTHNAME4, LOCALE_SMONTHNAME5, LOCALE_SMONTHNAME6, LOCALE_SMONTHNAME7, _
		    LOCALE_SMONTHNAME8, LOCALE_SMONTHNAME9, LOCALE_SMONTHNAME10, LOCALE_SMONTHNAME11, _
		    LOCALE_SMONTHNAME12, LOCALE_SMONTHNAME13 )
		    
		    ReDim MonthNames(12)
		    for i = 0 to 11
		      ret = GetLocaleInfo( monthConst( i ), mb, retVal )
		      MonthNames(i+1) = Titlecase( ConvertEncoding(retVal, Encodings.UTF8) )
		    next
		    
		    //Day of Week
		    Const LOCALE_IFIRSTDAYOFWEEK  = &h100C
		    ret = GetLocaleInfo( LOCALE_IFIRSTDAYOFWEEK, mb, retVal )
		    FirstDayOfWeek = (Val( retVal ) + 1) mod 7 + 1
		    
		  #else
		    
		    Dim D As New Date
		    
		    For i as integer = 0 to 6
		      DayNames(D.DayOfWeek) = D.LongDate.NthField(" ", 1).Replace(",", "")
		      D.Day = D.Day + 1
		    Next
		    
		    D.Day = 1
		    D.Month = 1
		    Dim MonthField As Integer
		    If IsNumeric(D.LongDate.NthField(" ", 2)) then
		      MonthField = 3
		    else
		      MonthField = 2
		    End If
		    If D.LongDate.NthField(" ", 3) = "de" then
		      MonthField = 4
		    End If
		    For i as Integer = 1 to 12
		      MonthNames(i) = TitleCase(D.LongDate.NthField(" ", MonthField)).Replace(",", "")
		      D.Month = D.Month + 1
		    Next
		    
		    FirstDayOfWeek = 1 //Sunday
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ViewChanged()
		  Dim lastFirstDate, lastLastDate As Date
		  
		  lastFirstDate = New Date(mFirstDate)
		  lastLastDate = New Date(mLastDate)
		  
		  
		  mFirstDate = Nil
		  mLastDate = Nil
		  
		  If LastDate <> Nil and FirstDate <> Nil and (lastFirstDate.TotalSeconds <> FirstDate.TotalSeconds or lastLastDate.TotalSeconds <> LastDate.TotalSeconds) then
		    
		    
		    
		    RaiseEvent ViewChange(FirstDate, LastDate)
		    
		  End If
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event DateSelected(D As Date)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Open()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ViewChange(StartDate As Date, EndDate As Date)
	#tag EndHook


	#tag Note, Name = History
		===Version 1.3.1 - Released 2016-===
		*New:
		**SelectedDate can be set to Nil (feature request)
		
		
		===Version 1.3.0 - Released 2015-===
		*New:
		**DateStyle dictionary to add special style to selected dates (feature request)
		
		===Version 1.2.0 - Released 2015-08-31===
		*Fix:
		**Registration issue 2015r4
		
		===Version 1.1.0 - Released 2015-02-27===
		*New:
		**Updated for Xojo 2015r1
		**SelectedDate property, cSt_dp_selecteddate WebStyle (User request)
		
		===Version 1.0.2 - Released 2014-11-12===
		*New:
		**Compatible with Xojo 2014r3
		
		===Version 1.0.1 - Released 2014-09-05===
		*New:
		**Included a DateTimePicker in the project.
		
		
		===Version 1.0 - Released 2014-08-27===
		*First public release
	#tag EndNote


	#tag Property, Flags = &h0
		#tag Note
			If True, the DatePicker will automatically calculate how many weeks are needed to display the whole month.
			If False, 6 weeks will always be displayed.
		#tag EndNote
		AdaptWeeksPerMonth As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			This dictionary is used to apply a WebStyle to special dates.
			
			The key of the dictionary should be the Date in SQL Format.<br/>
			The value is the WebStyle or WebStyle name.
			
			Example:
			
			Create a new style named Style1, with a red background.
			In the Open or Shown events of the DatePicker use the following code:
			
			aDatePicker.DateStyle.value("2015-01-09") = Style1 //Will add red background to September 1st, 2015
		#tag EndNote
		DateStyle As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The names of each day of Week, starting by Sunday.
			DayNames(1) = Sunday
			DayNames(7) = Saturday
		#tag EndNote
		Shared DayNames(7) As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			The currently displayed date.
		#tag EndNote
		#tag Getter
			Get
			  return mDisplayDate
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  
			  If mDisplayDate <> Nil and value <> Nil and value.SQLDate = mDisplayDate.SQLDate then
			    Return
			  End If
			  
			  If Value is Nil then
			    value = New Date
			  End If
			  
			  mDisplayDate = New Date(value)
			  
			  ViewChanged
			  
			  Redisplay()
			End Set
		#tag EndSetter
		DisplayDate As Date
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  
			  If mFirstDate is Nil then
			    
			    If DisplayDate is Nil then Return Nil
			    
			    
			    mFirstDate = New Date
			    
			    mFirstDate.TotalSeconds = DisplayDate.TotalSeconds
			    
			    mFirstDate.Day = 1
			    mFirstDate.Hour = 0
			    mFirstDate.Minute = 0
			    mFirstDate.Second = 0
			    If AdaptWeeksPerMonth then
			      
			      If mFirstDate.DayOfWeek - FirstDayOfWeek < 0 then
			        mFirstDate.Day = mFirstDate.Day - (mFirstDate.DayOfWeek - FirstDayOfWeek) - 7
			      else
			        mFirstDate.Day = mFirstDate.Day - (mFirstDate.DayOfWeek - FirstDayOfWeek)
			      End If
			      
			    else
			      
			      WeeksPerMonth = 6
			      
			      If mFirstDate.DayOfWeek - FirstDayOfWeek <= 0 then
			        mFirstDate.Day = mFirstDate.Day - (mFirstDate.DayOfWeek - FirstDayOfWeek) - 7
			      else
			        mFirstDate.Day = mFirstDate.Day - (mFirstDate.DayOfWeek - FirstDayOfWeek)
			      End If
			    End If
			    
			    
			  End If
			  
			  return New Date(mFirstDate)
			End Get
		#tag EndGetter
		FirstDate As Date
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mFirstDayOfWeek
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mFirstDayOfWeek = value
			  
			  ViewChanged
			  
			  Redisplay()
			End Set
		#tag EndSetter
		FirstDayOfWeek As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mLastDate is Nil then
			    
			    If DisplayDate is Nil then Return Nil
			    
			    
			    
			    If AdaptWeeksPerMonth then
			      mLastDate = New Date(DisplayDate)
			      
			      mLastDate.Day = 1
			      mLastDate.Month = mLastDate.Month + 1
			      mLastDate.Day = mLastDate.Day - 1
			      mLastDate.Hour = 0
			      mLastDate.Minute  =0
			      mLastDate.Second = 0
			      
			      WeeksPerMonth = Ceil((mLastDate.TotalSeconds - FirstDate.TotalSeconds + 86400) / 604800)
			      
			      mLastDate.TotalSeconds = FirstDate.TotalSeconds
			      mLastDate.Day = mLastDate.Day + WeeksPerMonth * 7
			    else
			      WeeksPerMonth = 6
			      mLastDate = New Date( FirstDate)
			      mLastDate.Day = mLastDate.Day + 42
			      
			      
			    End If
			    mLastDate.Second = mLastDate.Second - 1
			    
			    
			  End If
			  
			  
			  
			  
			  return New Date(mLastDate)
			End Get
		#tag EndGetter
		LastDate As Date
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mDisplayDate As Date
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFirstDate As Date
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFirstDayOfWeek As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastDate As Date
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mLimitDate As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Month names from MonthNames(1)=January to MonthNames(12)=December.
			
			On Windows, the MonthNames are automatically retrieved.
			On Macintosh and Linux, the CalendarView will try to retrieve the MonthNames using Date.LongDate.
			
			Set this property in the Open event, never in the Shown event for Web Applications.
		#tag EndNote
		Shared MonthNames(12) As String
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The selected Date either clicked by user, or set by code.
			
			Setting SelectedDate by code will update the DisplayDate.<br>
			Set SelectedDate = Nil to reset SelectedDate and not display the cSt_dp_selecteddate WebStyle.
		#tag EndNote
		Private mSelectedDate As Date
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			The currently selected date.
			
			The selected date uses cSt_dp_selecteddate WebStyle.<br/>
			Setting SelectedDate = Nil will remove the SelectedDate Webstyle.
			
			Setting SelectedDate by code will update the DisplayDate.
			
		#tag EndNote
		#tag Getter
			Get
			  return mSelectedDate
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mSelectedDate = value
			  
			  If value <> Nil and value.SQLDate <> DisplayDate.SQLDate then
			    DisplayDate = New Date(value)
			    
			    ViewChanged()
			    
			    Redisplay()
			    
			    
			  Elseif value is nil then
			    Dim d As new date
			    if DisplayDate.SQLDate <> d.SQLDate then
			      
			      DisplayDate = new date
			      
			    End if
			    
			    ViewChanged()
			    
			    Redisplay()
			    
			    
			  End If
			End Set
		#tag EndSetter
		SelectedDate As Date
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected WeeksPerMonth As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True, user also has the option to scroll by years.
		#tag EndNote
		YearSelector As Boolean
	#tag EndProperty


	#tag Constant, Name = JavascriptNameSpace, Type = String, Dynamic = False, Default = \"jly.WebDatePicker", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kProductKey, Type = String, Dynamic = False, Default = \"WebDatePicker", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kReleaseDate, Type = Double, Dynamic = False, Default = \"20161028", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"1.3.1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LayoutEditorIcon, Type = String, Dynamic = False, Default = \"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\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = NavigatorIcon, Type = String, Dynamic = False, Default = \"iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAACxIAAAsSAdLdfvwAAAITSURBVDhPnZFNiFJhFIZvRBHTwoZm0WYYZ9GihSRTkObPzCJH+zHyZgNNg9EipBYDBbYQh5btgnZBYdGklY5wZxGUQoI/gzgqJpqCvwsXISQmoqBX3+730QxMijUdePgu5573/d57LsMINXH9yIT4zozIarM+s6xZLFO3josOXjuwh8PsIdHq2updm8326sz9uUnh/VGipSV5I3adfD2Ft651PH3/BDP2YyN57HwEbpPDqRcnILZP+qlYqVbMLq+rvi99XMTKp8swfdbD5LuIm4HTQ5jCc7gtsByUYsl19seCRjXLyOQyw713izB7V2ANPMSljQWYvxjx4KtyLGZuHkqV0iAYnGM/+Oz49nPrn8kIs5tbDsFAwVKDQDAAUoPBgJ5/Fs/ze1r9fh/bse1hg2QyuTs47rnb7SIcDg8bjEux40zSNJtNeH3e/0tQr9dRrVbhdrtGJxi5hN9NIq5UKojH4+A47u8JyFIJZB9EXC6XkUgkEAqFaI/+BblcxgZDATq4A8/36J29Xg+dTmdXHIlE6PJyuRxqtRo0mgsso55X099IBgntdhutVguNRoMOkcjkNr/fT4lGoygWi7RvvGFkGZ1Oy7o33MhkMigUCiiVSsjn88hms0in01Qci8WokJypVIrOkM/QX9WzjFanNTicDng8nn3hcDpxRa83MBKJZFp2XvFcrlC+3A9EI5VKp38Bz93IsEUPsGEAAAAASUVORK5CYII\x3D", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = ShowStyleProperty, Type = Boolean, Dynamic = False, Default = \"True", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_OpenEventFired"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Cursor"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Automatic"
				"1 - Standard Pointer"
				"2 - Finger Pointer"
				"3 - IBeam"
				"4 - Wait"
				"5 - Help"
				"6 - Arrow All Directions"
				"7 - Arrow North"
				"8 - Arrow South"
				"9 - Arrow East"
				"10 - Arrow West"
				"11 - Arrow Northeast"
				"12 - Arrow Northwest"
				"13 - Arrow Southeast"
				"14 - Arrow Southwest"
				"15 - Splitter East West"
				"16 - Splitter North South"
				"17 - Progress"
				"18 - No Drop"
				"19 - Not Allowed"
				"20 - Vertical IBeam"
				"21 - Crosshair"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Behavior"
			InitialValue="170"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTag"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HorizontalCenter"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockHorizontal"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockVertical"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabOrder"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="VerticalCenter"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Behavior"
			InitialValue="200"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ZIndex"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_DeclareLineRendered"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_HorizontalPercent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_IsEmbedded"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_Locked"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_NeedsRendering"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_OfficialControl"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_VerticalPercent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstDayOfWeek"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Sunday"
				"1 - Monday"
				"2 - Tuesday"
				"3 - Wednesday"
				"4 - Thursday"
				"5 - Friday"
				"6 - Saturday"
				"7 - Sunday"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="AdaptWeeksPerMonth"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="YearSelector"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
