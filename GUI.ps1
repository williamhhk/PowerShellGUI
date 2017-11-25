function Invoke-GUI { #Begin function Invoke-GUI
    [cmdletbinding()]
    Param()

    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
    [void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

    $inputXML = @"
<Window x:Class="WpfApp1.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp1"
        mc:Ignorable="d"
        Title="MainWindow" Height="350" Width="525">
    <Grid>
        <TextBox x:Name="txtIPAddress" HorizontalAlignment="Left" Height="23" Margin="183,13,0,0" TextWrapping="Wrap" Text="" VerticalAlignment="Top" Width="120"/>
        <Label Content="IP Address" HorizontalAlignment="Left" Margin="41,10,0,0" VerticalAlignment="Top"/>
        <Button x:Name="btnShow" Content="Save" HorizontalAlignment="Left" Height="29" Margin="423,212,0,0" VerticalAlignment="Top" Width="66"/>
        <TextBox x:Name="txtEcho" HorizontalAlignment="Left" Height="61" Margin="183,77,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="120"/>
    </Grid>
</Window>
"@  

    [xml]$XAML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window' 
    
    #Read XAML 
    $reader=(New-Object System.Xml.XmlNodeReader $xaml) 
    try {
    
        $Form=[Windows.Markup.XamlReader]::Load( $reader )
        
    }

    catch {
    
        Write-Error "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."
        
    }
 
    #Create variables to control form elements as objects in PowerShell
    $xaml.SelectNodes("//*[@Name]") | ForEach-Object {
    
        Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) -Scope Global
        
    } 

    $WPFbtnShow.Add_Click{
        Write-Host $WPFtxtIPAddress.Text
        $WPFtxtEcho.Text = $WPFtxtIPAddress.Text

    }

    #Show form
    $form.ShowDialog() | Out-Null

}
    


#Call function to open the form
Invoke-GUI
