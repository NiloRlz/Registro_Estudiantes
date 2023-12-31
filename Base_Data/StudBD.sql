USE [master]
GO
/****** Object:  Database [StudBD]    Script Date: 15/09/2023 17:40:19 ******/
CREATE DATABASE [StudBD]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DBTeam', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DBTeam.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DBTeam_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\DBTeam_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [StudBD] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [StudBD].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [StudBD] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [StudBD] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [StudBD] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [StudBD] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [StudBD] SET ARITHABORT OFF 
GO
ALTER DATABASE [StudBD] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [StudBD] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [StudBD] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [StudBD] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [StudBD] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [StudBD] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [StudBD] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [StudBD] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [StudBD] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [StudBD] SET  ENABLE_BROKER 
GO
ALTER DATABASE [StudBD] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [StudBD] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [StudBD] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [StudBD] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [StudBD] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [StudBD] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [StudBD] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [StudBD] SET RECOVERY FULL 
GO
ALTER DATABASE [StudBD] SET  MULTI_USER 
GO
ALTER DATABASE [StudBD] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [StudBD] SET DB_CHAINING OFF 
GO
ALTER DATABASE [StudBD] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [StudBD] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [StudBD] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [StudBD] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'StudBD', N'ON'
GO
ALTER DATABASE [StudBD] SET QUERY_STORE = ON
GO
ALTER DATABASE [StudBD] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [StudBD]
GO
/****** Object:  Table [dbo].[clientes]    Script Date: 15/09/2023 17:40:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clientes](
	[codigo] [varchar](5) NULL,
	[nombre] [varchar](50) NULL,
	[edad] [int] NULL,
	[telefono] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[sp_buscar_clientes]    Script Date: 15/09/2023 17:40:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_buscar_clientes]
@nombre varchar(50)
as
select codigo,nombre,edad,telefono from clientes where nombre like @nombre + '%'
GO
/****** Object:  StoredProcedure [dbo].[sp_listar_clientes]    Script Date: 15/09/2023 17:40:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_listar_clientes]
as
select * from clientes order by codigo
GO
/****** Object:  StoredProcedure [dbo].[sp_mantenimiento_clientes]    Script Date: 15/09/2023 17:40:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_mantenimiento_clientes]
@codigo varchar(5),
@nombre varchar(50),
@edad int,
@telefono int,
@accion varchar(50) output
as
if (@accion='1')
begin
	declare @codnuevo varchar(5), @codmax varchar(5)
	set @codmax = (select max(codigo) from clientes)
	set @codmax = isnull(@codmax,'A0000')
	set @codnuevo = 'A'+RIGHT(RIGHT(@codmax,4)+10001,4)
	insert into clientes(codigo,nombre,edad,telefono)
	values(@codnuevo,@nombre,@edad,@telefono)
	set @accion='Se genero el código: ' +@codnuevo
end
else if (@accion='2')
begin
	update clientes set nombre=@nombre, edad=@edad, telefono=@telefono where codigo=@codigo
	set @accion='Se modifico el código: ' +@codigo
end
else if (@accion='3')
begin
	delete from clientes where codigo=@codigo
	set @accion='Se borro el código: ' +@codigo
end
GO
USE [master]
GO
ALTER DATABASE [StudBD] SET  READ_WRITE 
GO
