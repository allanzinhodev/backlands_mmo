-- phpMyAdmin SQL Dump
-- version 4.0.10deb1ubuntu0.1
-- http://www.phpmyadmin.net
--
-- Máquina: localhost
-- Data de Criação: 04-Dez-2019 às 15:01
-- Versão do servidor: 5.5.62-0ubuntu0.14.04.1
-- versão do PHP: 5.5.9-1ubuntu4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de Dados: `nto`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `accounts`
--

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL,
  `salt` varchar(40) NOT NULL DEFAULT '',
  `premdays` int(11) NOT NULL DEFAULT '0',
  `lastday` int(10) unsigned NOT NULL DEFAULT '0',
  `email` varchar(255) NOT NULL DEFAULT '',
  `key` varchar(32) NOT NULL DEFAULT '0',
  `blocked` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'internal usage',
  `warnings` int(11) NOT NULL DEFAULT '0',
  `group_id` int(11) NOT NULL DEFAULT '1',
  `email_new` varchar(255) NOT NULL DEFAULT '',
  `email_new_time` int(11) NOT NULL DEFAULT '0',
  `rlname` varchar(255) NOT NULL DEFAULT '',
  `location` varchar(255) NOT NULL DEFAULT '',
  `page_access` int(11) NOT NULL DEFAULT '0',
  `email_code` varchar(255) NOT NULL DEFAULT '',
  `next_email` int(11) NOT NULL DEFAULT '0',
  `premium_points` int(11) NOT NULL DEFAULT '0',
  `create_date` int(11) NOT NULL DEFAULT '0',
  `create_ip` int(11) NOT NULL DEFAULT '0',
  `last_post` int(11) NOT NULL DEFAULT '0',
  `flag` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Extraindo dados da tabela `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `password`, `salt`, `premdays`, `lastday`, `email`, `key`, `blocked`, `warnings`, `group_id`, `email_new`, `email_new_time`, `rlname`, `location`, `page_access`, `email_code`, `next_email`, `premium_points`, `create_date`, `create_ip`, `last_post`, `flag`) VALUES
(1, '1', '99baee504a1fe91a07bc66b6900bd39874191889', '', 65535, 1575386523, '', '0', 0, 0, 1, '', 0, '', '', 3, '', 0, 0, 0, 0, 0, 'unknown');

--
-- Acionadores `accounts`
--
DROP TRIGGER IF EXISTS `ondelete_accounts`;
DELIMITER //
CREATE TRIGGER `ondelete_accounts` BEFORE DELETE ON `accounts`
 FOR EACH ROW BEGIN
	DELETE FROM `bans` WHERE `type` IN (3, 4) AND `value` = OLD.`id`;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `account_viplist`
--

CREATE TABLE IF NOT EXISTS `account_viplist` (
  `account_id` int(11) NOT NULL,
  `world_id` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `player_id` int(11) NOT NULL,
  UNIQUE KEY `account_id_2` (`account_id`,`player_id`),
  KEY `account_id` (`account_id`),
  KEY `player_id` (`player_id`),
  KEY `world_id` (`world_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `bans`
--

CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) NOT NULL COMMENT '1 - ip banishment, 2 - namelock, 3 - account banishment, 4 - notation, 5 - deletion',
  `value` int(10) unsigned NOT NULL COMMENT 'ip address (integer), player guid or account number',
  `param` int(10) unsigned NOT NULL DEFAULT '4294967295' COMMENT 'used only for ip banishment mask (integer)',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `expires` int(11) NOT NULL,
  `added` int(10) unsigned NOT NULL,
  `admin_id` int(10) unsigned NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  `reason` int(10) unsigned NOT NULL DEFAULT '0',
  `action` int(10) unsigned NOT NULL DEFAULT '0',
  `statement` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `type` (`type`,`value`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `bounty_hunters`
--

CREATE TABLE IF NOT EXISTS `bounty_hunters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fp_id` int(11) NOT NULL,
  `sp_id` int(11) NOT NULL,
  `k_id` int(11) NOT NULL,
  `added` int(15) NOT NULL,
  `prize` bigint(20) NOT NULL,
  `killed` int(11) NOT NULL,
  `kill_time` int(15) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `environment_killers`
--

CREATE TABLE IF NOT EXISTS `environment_killers` (
  `kill_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  KEY `kill_id` (`kill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `global_storage`
--

CREATE TABLE IF NOT EXISTS `global_storage` (
  `key` varchar(32) NOT NULL DEFAULT '0',
  `world_id` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '0',
  UNIQUE KEY `key` (`key`,`world_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `global_storage`
--

INSERT INTO `global_storage` (`key`, `world_id`, `value`) VALUES
('1821291', 0, '-1'),
('2381121', 0, '-1'),
('2860', 0, '0'),
('cidShootingOne', 0, '0'),
('cidShootingThree', 0, '0'),
('cidShootingTwo', 0, '0');

-- --------------------------------------------------------

--
-- Estrutura da tabela `guilds`
--

CREATE TABLE IF NOT EXISTS `guilds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `world_id` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `creationdata` int(11) NOT NULL,
  `checkdata` int(11) NOT NULL,
  `motd` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `guild_logo` mediumblob,
  `create_ip` int(11) NOT NULL DEFAULT '0',
  `balance` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`world_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Acionadores `guilds`
--
DROP TRIGGER IF EXISTS `oncreate_guilds`;
DELIMITER //
CREATE TRIGGER `oncreate_guilds` AFTER INSERT ON `guilds`
 FOR EACH ROW BEGIN
	INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('Leader', 3, NEW.`id`);
	INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('Vice-Leader', 2, NEW.`id`);
	INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('Member', 1, NEW.`id`);
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `ondelete_guilds`;
DELIMITER //
CREATE TRIGGER `ondelete_guilds` BEFORE DELETE ON `guilds`
 FOR EACH ROW BEGIN
	UPDATE `players` SET `guildnick` = '', `rank_id` = 0 WHERE `rank_id` IN (SELECT `id` FROM `guild_ranks` WHERE `guild_id` = OLD.`id`);
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `guild_invites`
--

CREATE TABLE IF NOT EXISTS `guild_invites` (
  `player_id` int(11) NOT NULL DEFAULT '0',
  `guild_id` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `player_id` (`player_id`,`guild_id`),
  KEY `guild_id` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `guild_kills`
--

CREATE TABLE IF NOT EXISTS `guild_kills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guild_id` int(11) NOT NULL,
  `war_id` int(11) NOT NULL,
  `death_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `guild_kills_ibfk_1` (`war_id`),
  KEY `guild_kills_ibfk_2` (`death_id`),
  KEY `guild_kills_ibfk_3` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `guild_ranks`
--

CREATE TABLE IF NOT EXISTS `guild_ranks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guild_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `level` int(11) NOT NULL COMMENT '1 - leader, 2 - vice leader, 3 - member',
  PRIMARY KEY (`id`),
  KEY `guild_id` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `guild_wars`
--

CREATE TABLE IF NOT EXISTS `guild_wars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guild_id` int(11) NOT NULL,
  `enemy_id` int(11) NOT NULL,
  `begin` bigint(20) NOT NULL DEFAULT '0',
  `end` bigint(20) NOT NULL DEFAULT '0',
  `frags` int(10) unsigned NOT NULL DEFAULT '0',
  `payment` bigint(20) unsigned NOT NULL DEFAULT '0',
  `guild_kills` int(10) unsigned NOT NULL DEFAULT '0',
  `enemy_kills` int(10) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `guild_id` (`guild_id`),
  KEY `enemy_id` (`enemy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `houses`
--

CREATE TABLE IF NOT EXISTS `houses` (
  `id` int(10) unsigned NOT NULL,
  `world_id` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `owner` int(11) NOT NULL,
  `paid` int(10) unsigned NOT NULL DEFAULT '0',
  `warnings` int(11) NOT NULL DEFAULT '0',
  `lastwarning` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `town` int(10) unsigned NOT NULL DEFAULT '0',
  `size` int(10) unsigned NOT NULL DEFAULT '0',
  `price` int(10) unsigned NOT NULL DEFAULT '0',
  `rent` int(10) unsigned NOT NULL DEFAULT '0',
  `doors` int(10) unsigned NOT NULL DEFAULT '0',
  `beds` int(10) unsigned NOT NULL DEFAULT '0',
  `tiles` int(10) unsigned NOT NULL DEFAULT '0',
  `guild` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `clear` tinyint(1) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `id` (`id`,`world_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `houses`
--

INSERT INTO `houses` (`id`, `world_id`, `owner`, `paid`, `warnings`, `lastwarning`, `name`, `town`, `size`, `price`, `rent`, `doors`, `beds`, `tiles`, `guild`, `clear`) VALUES
(88, 0, 0, 0, 0, 0, 'Konoha Central Flat #1', 1, 20, 39000, 10000, 1, 4, 39, 0, 0),
(89, 0, 0, 0, 0, 0, 'Konoha Central Flat #2', 1, 27, 40000, 10000, 1, 4, 40, 0, 0),
(90, 0, 0, 0, 0, 0, 'Konoha Central Flat #3', 1, 14, 25000, 5000, 1, 2, 25, 0, 0),
(91, 0, 0, 0, 0, 0, 'Konoha Flat #4', 1, 20, 39000, 8000, 1, 4, 39, 0, 0),
(92, 0, 0, 0, 0, 0, 'Konoha Flat #5', 1, 20, 30000, 8000, 1, 4, 30, 0, 0),
(93, 0, 0, 0, 0, 0, 'Konoha Flat #6', 1, 23, 41000, 15000, 1, 4, 41, 0, 0),
(94, 0, 0, 0, 0, 0, 'Konoha Flats #7', 1, 7, 12000, 5000, 1, 2, 12, 0, 0),
(95, 0, 0, 0, 0, 0, 'Konoha Flats #8', 1, 28, 40000, 15000, 1, 4, 40, 0, 0),
(96, 0, 0, 0, 0, 0, 'Konoha Flats #9', 1, 9, 21000, 1000, 1, 2, 21, 0, 0),
(97, 0, 0, 0, 0, 0, 'Konoha Flats #10', 1, 26, 56000, 5000, 1, 4, 56, 0, 0),
(98, 0, 0, 0, 0, 0, 'Konoha Flats #11', 1, 24, 44000, 3500, 1, 6, 44, 0, 0),
(99, 0, 0, 0, 0, 0, 'Konoha Flats #12', 1, 18, 34000, 1500, 1, 2, 34, 0, 0),
(100, 0, 0, 0, 0, 0, 'Konoha Flats #13', 1, 12, 23000, 1000, 1, 2, 23, 0, 0),
(101, 0, 0, 0, 0, 0, 'Konoha Flats #14', 1, 10, 19000, 1000, 1, 2, 19, 0, 0),
(102, 0, 0, 0, 0, 0, 'Konoha Flats #15', 1, 10, 21000, 1000, 1, 2, 21, 0, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `house_auctions`
--

CREATE TABLE IF NOT EXISTS `house_auctions` (
  `house_id` int(10) unsigned NOT NULL,
  `world_id` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `player_id` int(11) NOT NULL,
  `bid` int(10) unsigned NOT NULL DEFAULT '0',
  `limit` int(10) unsigned NOT NULL DEFAULT '0',
  `endtime` bigint(20) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `house_id` (`house_id`,`world_id`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `house_data`
--

CREATE TABLE IF NOT EXISTS `house_data` (
  `house_id` int(10) unsigned NOT NULL,
  `world_id` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `data` longblob NOT NULL,
  UNIQUE KEY `house_id` (`house_id`,`world_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `house_lists`
--

CREATE TABLE IF NOT EXISTS `house_lists` (
  `house_id` int(10) unsigned NOT NULL,
  `world_id` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `listid` int(11) NOT NULL,
  `list` text NOT NULL,
  UNIQUE KEY `house_id` (`house_id`,`world_id`,`listid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `killers`
--

CREATE TABLE IF NOT EXISTS `killers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `death_id` int(11) NOT NULL,
  `final_hit` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `unjustified` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `war` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `death_id` (`death_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=20 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `players`
--

CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `world_id` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `group_id` int(11) NOT NULL DEFAULT '1',
  `account_id` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  `vocation` int(11) NOT NULL DEFAULT '0',
  `health` int(11) NOT NULL DEFAULT '150',
  `healthmax` int(11) NOT NULL DEFAULT '150',
  `experience` bigint(20) NOT NULL DEFAULT '0',
  `lookbody` int(11) NOT NULL DEFAULT '0',
  `lookfeet` int(11) NOT NULL DEFAULT '0',
  `lookhead` int(11) NOT NULL DEFAULT '0',
  `looklegs` int(11) NOT NULL DEFAULT '0',
  `looktype` int(11) NOT NULL DEFAULT '136',
  `lookaddons` int(11) NOT NULL DEFAULT '0',
  `maglevel` int(11) NOT NULL DEFAULT '0',
  `mana` int(11) NOT NULL DEFAULT '0',
  `manamax` int(11) NOT NULL DEFAULT '0',
  `manaspent` int(11) NOT NULL DEFAULT '0',
  `soul` int(10) unsigned NOT NULL DEFAULT '0',
  `town_id` int(11) NOT NULL DEFAULT '0',
  `posx` int(11) NOT NULL DEFAULT '0',
  `posy` int(11) NOT NULL DEFAULT '0',
  `posz` int(11) NOT NULL DEFAULT '0',
  `conditions` blob NOT NULL,
  `cap` int(11) NOT NULL DEFAULT '0',
  `sex` int(11) NOT NULL DEFAULT '0',
  `lastlogin` bigint(20) unsigned NOT NULL DEFAULT '0',
  `lastip` int(10) unsigned NOT NULL DEFAULT '0',
  `save` tinyint(1) NOT NULL DEFAULT '1',
  `skull` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `skulltime` int(11) NOT NULL DEFAULT '0',
  `rank_id` int(11) NOT NULL DEFAULT '0',
  `guildnick` varchar(255) NOT NULL DEFAULT '',
  `lastlogout` bigint(20) unsigned NOT NULL DEFAULT '0',
  `blessings` tinyint(2) NOT NULL DEFAULT '0',
  `balance` bigint(20) NOT NULL DEFAULT '0',
  `stamina` bigint(20) NOT NULL DEFAULT '151200000' COMMENT 'stored in miliseconds',
  `direction` int(11) NOT NULL DEFAULT '2',
  `loss_experience` int(11) NOT NULL DEFAULT '100',
  `loss_mana` int(11) NOT NULL DEFAULT '100',
  `loss_skills` int(11) NOT NULL DEFAULT '100',
  `loss_containers` int(11) NOT NULL DEFAULT '100',
  `loss_items` int(11) NOT NULL DEFAULT '100',
  `premend` int(11) NOT NULL DEFAULT '0' COMMENT 'NOT IN USE BY THE SERVER',
  `online` tinyint(1) NOT NULL DEFAULT '0',
  `marriage` int(10) unsigned NOT NULL DEFAULT '0',
  `promotion` int(11) NOT NULL DEFAULT '0',
  `deleted` int(11) NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  `comment` text NOT NULL,
  `create_ip` int(11) NOT NULL DEFAULT '0',
  `create_date` int(11) NOT NULL DEFAULT '0',
  `hide_char` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`deleted`),
  KEY `account_id` (`account_id`),
  KEY `group_id` (`group_id`),
  KEY `online` (`online`),
  KEY `deleted` (`deleted`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;

--
-- Extraindo dados da tabela `players`
--

INSERT INTO `players` (`id`, `name`, `world_id`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons`, `maglevel`, `mana`, `manamax`, `manaspent`, `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`, `lastlogin`, `lastip`, `save`, `skull`, `skulltime`, `rank_id`, `guildnick`, `lastlogout`, `blessings`, `balance`, `stamina`, `direction`, `loss_experience`, `loss_mana`, `loss_skills`, `loss_containers`, `loss_items`, `premend`, `online`, `marriage`, `promotion`, `deleted`, `description`, `comment`, `create_ip`, `create_date`, `hide_char`) VALUES
(7, 'Maito Sample', 0, 1, 1, 1, 1, 150, 150, 0, 0, 0, 0, 0, 646, 0, 0, 0, 0, 0, 0, 0, 980, 1063, 7, '', 400, 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 201660000, 0, 100, 100, 100, 100, 100, 0, 0, 0, 0, 0, '', '', 0, 0, 0),
(8, 'Inuzuka Sample', 0, 1, 1, 1, 2, 150, 150, 0, 0, 0, 0, 0, 545, 0, 0, 0, 0, 0, 0, 0, 980, 1063, 7, '', 400, 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 201660000, 0, 100, 100, 100, 100, 100, 0, 0, 0, 0, 0, '', '', 0, 0, 0),
(9, 'Aburame Sample', 0, 1, 1, 1, 3, 150, 150, 0, 0, 0, 0, 0, 541, 0, 0, 0, 0, 0, 0, 0, 980, 1063, 7, '', 400, 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 201660000, 0, 100, 100, 100, 100, 100, 0, 0, 0, 0, 0, '', '', 0, 0, 0),
(10, 'Hyuuga Sample', 0, 1, 1, 1, 4, 150, 150, 0, 0, 0, 0, 0, 543, 0, 0, 0, 0, 0, 0, 0, 980, 1063, 7, '', 400, 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 201660000, 0, 100, 100, 100, 100, 100, 0, 0, 0, 0, 0, '', '', 0, 0, 0),
(11, 'Uchiha Sample', 0, 1, 1, 1, 5, 150, 150, 0, 0, 0, 0, 0, 547, 0, 0, 0, 0, 0, 0, 0, 980, 1063, 7, '', 400, 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 201660000, 0, 100, 100, 100, 100, 100, 0, 0, 0, 0, 0, '', '', 0, 0, 0),
(12, 'Nara Sample', 0, 1, 1, 1, 6, 150, 150, 0, 0, 0, 0, 0, 539, 0, 0, 0, 0, 0, 0, 0, 980, 1063, 7, '', 400, 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 201660000, 0, 100, 100, 100, 100, 100, 0, 0, 0, 0, 0, '', '', 0, 0, 0),
(13, 'Akimichi Sample', 0, 1, 1, 1, 7, 150, 150, 0, 0, 0, 0, 0, 643, 0, 0, 0, 0, 0, 0, 0, 980, 1063, 7, '', 400, 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 201660000, 0, 100, 100, 100, 100, 100, 0, 0, 0, 0, 0, '', '', 0, 0, 0);

--
-- Acionadores `players`
--
DROP TRIGGER IF EXISTS `oncreate_players`;
DELIMITER //
CREATE TRIGGER `oncreate_players` AFTER INSERT ON `players`
 FOR EACH ROW BEGIN
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 0, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 1, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 2, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 3, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 4, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 5, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 6, 10);
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `ondelete_players`;
DELIMITER //
CREATE TRIGGER `ondelete_players` BEFORE DELETE ON `players`
 FOR EACH ROW BEGIN
	DELETE FROM `bans` WHERE `type` IN (2, 5) AND `value` = OLD.`id`;
	UPDATE `houses` SET `owner` = 0 WHERE `owner` = OLD.`id`;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_deaths`
--

CREATE TABLE IF NOT EXISTS `player_deaths` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `player_id` int(11) NOT NULL,
  `date` bigint(20) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `date` (`date`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_depotitems`
--

CREATE TABLE IF NOT EXISTS `player_depotitems` (
  `player_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL COMMENT 'any given range, eg. 0-100 is reserved for depot lockers and all above 100 will be normal items inside depots',
  `pid` int(11) NOT NULL DEFAULT '0',
  `itemtype` int(11) NOT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL,
  UNIQUE KEY `player_id_2` (`player_id`,`sid`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_items`
--

CREATE TABLE IF NOT EXISTS `player_items` (
  `player_id` int(11) NOT NULL DEFAULT '0',
  `pid` int(11) NOT NULL DEFAULT '0',
  `sid` int(11) NOT NULL DEFAULT '0',
  `itemtype` int(11) NOT NULL DEFAULT '0',
  `count` int(11) NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL,
  UNIQUE KEY `player_id_2` (`player_id`,`sid`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_killers`
--

CREATE TABLE IF NOT EXISTS `player_killers` (
  `kill_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  KEY `kill_id` (`kill_id`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_namelocks`
--

CREATE TABLE IF NOT EXISTS `player_namelocks` (
  `player_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL,
  `new_name` varchar(255) NOT NULL,
  `date` bigint(20) NOT NULL DEFAULT '0',
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_skills`
--

CREATE TABLE IF NOT EXISTS `player_skills` (
  `player_id` int(11) NOT NULL DEFAULT '0',
  `skillid` tinyint(2) NOT NULL DEFAULT '0',
  `value` int(10) unsigned NOT NULL DEFAULT '0',
  `count` int(10) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `player_id_2` (`player_id`,`skillid`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `player_skills`
--

INSERT INTO `player_skills` (`player_id`, `skillid`, `value`, `count`) VALUES
(7, 0, 10, 0),
(7, 1, 10, 0),
(7, 2, 10, 0),
(7, 3, 10, 0),
(7, 4, 10, 0),
(7, 5, 10, 0),
(7, 6, 10, 0),
(8, 0, 10, 0),
(8, 1, 10, 0),
(8, 2, 10, 0),
(8, 3, 10, 0),
(8, 4, 10, 0),
(8, 5, 10, 0),
(8, 6, 10, 0),
(9, 0, 10, 0),
(9, 1, 10, 0),
(9, 2, 10, 0),
(9, 3, 10, 0),
(9, 4, 10, 0),
(9, 5, 10, 0),
(9, 6, 10, 0),
(10, 0, 10, 0),
(10, 1, 10, 0),
(10, 2, 10, 0),
(10, 3, 10, 0),
(10, 4, 10, 0),
(10, 5, 10, 0),
(10, 6, 10, 0),
(11, 0, 10, 0),
(11, 1, 10, 0),
(11, 2, 10, 0),
(11, 3, 10, 0),
(11, 4, 10, 0),
(11, 5, 10, 0),
(11, 6, 10, 0),
(12, 0, 10, 0),
(12, 1, 10, 0),
(12, 2, 10, 0),
(12, 3, 10, 0),
(12, 4, 10, 0),
(12, 5, 10, 0),
(12, 6, 10, 0),
(13, 0, 10, 0),
(13, 1, 10, 0),
(13, 2, 10, 0),
(13, 3, 10, 0),
(13, 4, 10, 0),
(13, 5, 10, 0),
(13, 6, 10, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_spells`
--

CREATE TABLE IF NOT EXISTS `player_spells` (
  `player_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  UNIQUE KEY `player_id_2` (`player_id`,`name`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_storage`
--

CREATE TABLE IF NOT EXISTS `player_storage` (
  `player_id` int(11) NOT NULL DEFAULT '0',
  `key` varchar(32) NOT NULL DEFAULT '0',
  `value` varchar(255) NOT NULL DEFAULT '0',
  UNIQUE KEY `player_id_2` (`player_id`,`key`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `player_viplist`
--

CREATE TABLE IF NOT EXISTS `player_viplist` (
  `player_id` int(11) NOT NULL,
  `vip_id` int(11) NOT NULL,
  UNIQUE KEY `player_id_2` (`player_id`,`vip_id`),
  KEY `player_id` (`player_id`),
  KEY `vip_id` (`vip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `server_config`
--

CREATE TABLE IF NOT EXISTS `server_config` (
  `config` varchar(35) NOT NULL DEFAULT '',
  `value` varchar(255) NOT NULL DEFAULT '',
  UNIQUE KEY `config` (`config`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `server_config`
--

INSERT INTO `server_config` (`config`, `value`) VALUES
('db_version', '27'),
('encryption', '2'),
('vahash_key', '24H3-QRTZ-6BH4-68YW');

-- --------------------------------------------------------

--
-- Estrutura da tabela `server_motd`
--

CREATE TABLE IF NOT EXISTS `server_motd` (
  `id` int(10) unsigned NOT NULL,
  `world_id` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  UNIQUE KEY `id` (`id`,`world_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `server_motd`
--

INSERT INTO `server_motd` (`id`, `world_id`, `text`) VALUES
(1, 0, 'Welcome to The Forgotten Server!'),
(2, 0, 'Welcome to the Alliance Server!');

-- --------------------------------------------------------

--
-- Estrutura da tabela `server_record`
--

CREATE TABLE IF NOT EXISTS `server_record` (
  `record` int(11) NOT NULL,
  `world_id` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `timestamp` bigint(20) NOT NULL,
  UNIQUE KEY `record` (`record`,`world_id`,`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `server_record`
--

INSERT INTO `server_record` (`record`, `world_id`, `timestamp`) VALUES
(0, 0, 0),
(1, 0, 1575295400),
(2, 0, 1575319348),
(3, 0, 1575321779),
(4, 0, 1575412241);

-- --------------------------------------------------------

--
-- Estrutura da tabela `server_reports`
--

CREATE TABLE IF NOT EXISTS `server_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `world_id` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `player_id` int(11) NOT NULL DEFAULT '1',
  `posx` int(11) NOT NULL DEFAULT '0',
  `posy` int(11) NOT NULL DEFAULT '0',
  `posz` int(11) NOT NULL DEFAULT '0',
  `timestamp` bigint(20) NOT NULL DEFAULT '0',
  `report` text NOT NULL,
  `reads` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `world_id` (`world_id`),
  KEY `reads` (`reads`),
  KEY `player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tiles`
--

CREATE TABLE IF NOT EXISTS `tiles` (
  `id` int(10) unsigned NOT NULL,
  `world_id` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `house_id` int(10) unsigned NOT NULL,
  `x` int(5) unsigned NOT NULL,
  `y` int(5) unsigned NOT NULL,
  `z` tinyint(2) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`,`world_id`),
  KEY `x` (`x`,`y`,`z`),
  KEY `house_id` (`house_id`,`world_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `tiles`
--

INSERT INTO `tiles` (`id`, `world_id`, `house_id`, `x`, `y`, `z`) VALUES
(0, 0, 88, 2597, 1817, 6),
(1, 0, 88, 2597, 1818, 6),
(2, 0, 88, 2596, 1819, 7),
(3, 0, 88, 2597, 1817, 7),
(4, 0, 88, 2597, 1818, 7),
(5, 0, 89, 2602, 1819, 7),
(6, 0, 89, 2603, 1816, 7),
(7, 0, 89, 2603, 1819, 7),
(8, 0, 89, 2606, 1817, 6),
(9, 0, 89, 2606, 1818, 6),
(10, 0, 90, 2602, 1821, 7),
(11, 0, 90, 2602, 1822, 7),
(12, 0, 90, 2605, 1825, 7),
(13, 0, 91, 2612, 1817, 6),
(14, 0, 91, 2612, 1818, 6),
(15, 0, 91, 2612, 1816, 7),
(16, 0, 91, 2610, 1820, 7),
(17, 0, 91, 2611, 1820, 7),
(18, 0, 92, 2616, 1817, 6),
(19, 0, 92, 2616, 1818, 6),
(20, 0, 92, 2616, 1816, 7),
(21, 0, 92, 2614, 1820, 7),
(22, 0, 92, 2615, 1820, 7),
(23, 0, 93, 2612, 1823, 6),
(24, 0, 93, 2610, 1824, 5),
(25, 0, 93, 2611, 1824, 5),
(26, 0, 93, 2609, 1824, 6),
(27, 0, 93, 2612, 1824, 6),
(28, 0, 94, 2610, 1822, 7),
(29, 0, 94, 2610, 1823, 7),
(30, 0, 94, 2613, 1824, 7),
(31, 0, 95, 2602, 1821, 5),
(32, 0, 95, 2602, 1822, 5),
(33, 0, 95, 2602, 1821, 6),
(34, 0, 95, 2602, 1822, 6),
(35, 0, 95, 2606, 1824, 6),
(36, 0, 96, 2437, 1733, 7),
(37, 0, 96, 2441, 1732, 7),
(38, 0, 96, 2441, 1733, 7),
(39, 0, 97, 2432, 1726, 7),
(40, 0, 97, 2436, 1726, 7),
(41, 0, 97, 2436, 1727, 7),
(42, 0, 97, 2438, 1726, 7),
(43, 0, 97, 2438, 1727, 7),
(44, 0, 98, 2431, 1727, 6),
(45, 0, 98, 2433, 1727, 6),
(46, 0, 98, 2435, 1727, 6),
(47, 0, 98, 2431, 1728, 6),
(48, 0, 98, 2433, 1728, 6),
(49, 0, 98, 2435, 1728, 6),
(50, 0, 98, 2436, 1730, 6),
(51, 0, 99, 2427, 1734, 7),
(52, 0, 99, 2432, 1731, 7),
(53, 0, 99, 2432, 1732, 7),
(54, 0, 100, 2431, 1741, 7),
(55, 0, 100, 2435, 1738, 7),
(56, 0, 100, 2435, 1739, 7),
(57, 0, 101, 2437, 1739, 7),
(58, 0, 101, 2438, 1739, 7),
(59, 0, 101, 2440, 1739, 7),
(60, 0, 102, 2432, 1739, 6),
(61, 0, 102, 2432, 1740, 6),
(62, 0, 102, 2434, 1742, 6);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tile_items`
--

CREATE TABLE IF NOT EXISTS `tile_items` (
  `tile_id` int(10) unsigned NOT NULL,
  `world_id` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `sid` int(11) NOT NULL,
  `pid` int(11) NOT NULL DEFAULT '0',
  `itemtype` int(11) NOT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  `attributes` blob NOT NULL,
  UNIQUE KEY `tile_id` (`tile_id`,`world_id`,`sid`),
  KEY `sid` (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Extraindo dados da tabela `tile_items`
--

INSERT INTO `tile_items` (`tile_id`, `world_id`, `sid`, `pid`, `itemtype`, `count`, `attributes`) VALUES
(0, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(2, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e016000000049742062656c6f6e677320746f20686f75736520274b6f6e6f68612043656e7472616c20466c6174202331272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320333930303020676f6c6420636f696e732e0600646f6f7269640201000000),
(3, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(4, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(5, 0, 1, 0, 1760, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(6, 0, 1, 0, 1222, 1, 0x8002000b006465736372697074696f6e016000000049742062656c6f6e677320746f20686f75736520274b6f6e6f68612043656e7472616c20466c6174202332272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320343030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(7, 0, 1, 0, 1761, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(8, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(9, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(10, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(11, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(12, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e016000000049742062656c6f6e677320746f20686f75736520274b6f6e6f68612043656e7472616c20466c6174202333272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320323530303020676f6c6420636f696e732e0600646f6f7269640201000000),
(13, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(14, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(15, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015800000049742062656c6f6e677320746f20686f75736520274b6f6e6f686120466c6174202334272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320333930303020676f6c6420636f696e732e0600646f6f7269640201000000),
(16, 0, 1, 0, 1760, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(17, 0, 1, 0, 1761, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(18, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(19, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(20, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015800000049742062656c6f6e677320746f20686f75736520274b6f6e6f686120466c6174202335272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320333030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(21, 0, 1, 0, 1760, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(22, 0, 1, 0, 1761, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(23, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(24, 0, 1, 0, 1760, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(25, 0, 1, 0, 1761, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(26, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015800000049742062656c6f6e677320746f20686f75736520274b6f6e6f686120466c6174202336272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320343130303020676f6c6420636f696e732e0600646f6f7269640201000000),
(27, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(28, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(29, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(30, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015900000049742062656c6f6e677320746f20686f75736520274b6f6e6f686120466c617473202337272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320313230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(31, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(32, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(33, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(34, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(35, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015900000049742062656c6f6e677320746f20686f75736520274b6f6e6f686120466c617473202338272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320343030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(36, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015900000049742062656c6f6e677320746f20686f75736520274b6f6e6f686120466c617473202339272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320323130303020676f6c6420636f696e732e0600646f6f7269640201000000),
(37, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(38, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(39, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015a00000049742062656c6f6e677320746f20686f75736520274b6f6e6f686120466c61747320233130272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320353630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(40, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(41, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(42, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(43, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(44, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(45, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(46, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(47, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(48, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(49, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(50, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015a00000049742062656c6f6e677320746f20686f75736520274b6f6e6f686120466c61747320233131272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320343430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(51, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015a00000049742062656c6f6e677320746f20686f75736520274b6f6e6f686120466c61747320233132272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320333430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(52, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(53, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(54, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015a00000049742062656c6f6e677320746f20686f75736520274b6f6e6f686120466c61747320233133272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320323330303020676f6c6420636f696e732e0600646f6f7269640202000000),
(55, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(56, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(57, 0, 1, 0, 1760, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(58, 0, 1, 0, 1761, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(59, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015a00000049742062656c6f6e677320746f20686f75736520274b6f6e6f686120466c61747320233134272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320313930303020676f6c6420636f696e732e0600646f6f7269640202000000),
(60, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(61, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(62, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015a00000049742062656c6f6e677320746f20686f75736520274b6f6e6f686120466c61747320233135272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320323130303020676f6c6420636f696e732e0600646f6f7269640201000000);

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_forum`
--

CREATE TABLE IF NOT EXISTS `z_forum` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_post` int(11) NOT NULL DEFAULT '0',
  `last_post` int(11) NOT NULL DEFAULT '0',
  `section` int(3) NOT NULL DEFAULT '0',
  `replies` int(20) NOT NULL DEFAULT '0',
  `views` int(20) NOT NULL DEFAULT '0',
  `author_aid` int(20) NOT NULL DEFAULT '0',
  `author_guid` int(20) NOT NULL DEFAULT '0',
  `post_text` text NOT NULL,
  `post_topic` varchar(255) NOT NULL,
  `post_smile` tinyint(1) NOT NULL DEFAULT '0',
  `post_date` int(20) NOT NULL DEFAULT '0',
  `last_edit_aid` int(20) NOT NULL DEFAULT '0',
  `edit_date` int(20) NOT NULL DEFAULT '0',
  `post_ip` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  PRIMARY KEY (`id`),
  KEY `section` (`section`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_ots_comunication`
--

CREATE TABLE IF NOT EXISTS `z_ots_comunication` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `param1` varchar(255) NOT NULL,
  `param2` varchar(255) NOT NULL,
  `param3` varchar(255) NOT NULL,
  `param4` varchar(255) NOT NULL,
  `param5` varchar(255) NOT NULL,
  `param6` varchar(255) NOT NULL,
  `param7` varchar(255) NOT NULL,
  `delete_it` int(2) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_shop_history_item`
--

CREATE TABLE IF NOT EXISTS `z_shop_history_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `to_name` varchar(255) NOT NULL DEFAULT '0',
  `to_account` int(11) NOT NULL DEFAULT '0',
  `from_nick` varchar(255) NOT NULL,
  `from_account` int(11) NOT NULL DEFAULT '0',
  `price` int(11) NOT NULL DEFAULT '0',
  `offer_id` varchar(255) NOT NULL DEFAULT '',
  `trans_state` varchar(255) NOT NULL,
  `trans_start` int(11) NOT NULL DEFAULT '0',
  `trans_real` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `z_shop_offer`
--

CREATE TABLE IF NOT EXISTS `z_shop_offer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `points` int(11) NOT NULL DEFAULT '0',
  `itemid1` int(11) NOT NULL DEFAULT '0',
  `count1` int(11) NOT NULL DEFAULT '0',
  `itemid2` int(11) NOT NULL DEFAULT '0',
  `count2` int(11) NOT NULL DEFAULT '0',
  `offer_type` varchar(255) DEFAULT NULL,
  `offer_description` text NOT NULL,
  `offer_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD CONSTRAINT `account_viplist_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `account_viplist_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `environment_killers`
--
ALTER TABLE `environment_killers`
  ADD CONSTRAINT `environment_killers_ibfk_1` FOREIGN KEY (`kill_id`) REFERENCES `killers` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD CONSTRAINT `guild_invites_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guild_invites_ibfk_2` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guild_kills`
--
ALTER TABLE `guild_kills`
  ADD CONSTRAINT `guild_kills_ibfk_1` FOREIGN KEY (`war_id`) REFERENCES `guild_wars` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guild_kills_ibfk_2` FOREIGN KEY (`death_id`) REFERENCES `player_deaths` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guild_kills_ibfk_3` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD CONSTRAINT `guild_ranks_ibfk_1` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `guild_wars`
--
ALTER TABLE `guild_wars`
  ADD CONSTRAINT `guild_wars_ibfk_1` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guild_wars_ibfk_2` FOREIGN KEY (`enemy_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `house_auctions`
--
ALTER TABLE `house_auctions`
  ADD CONSTRAINT `house_auctions_ibfk_1` FOREIGN KEY (`house_id`, `world_id`) REFERENCES `houses` (`id`, `world_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `house_auctions_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `house_data`
--
ALTER TABLE `house_data`
  ADD CONSTRAINT `house_data_ibfk_1` FOREIGN KEY (`house_id`, `world_id`) REFERENCES `houses` (`id`, `world_id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `house_lists`
--
ALTER TABLE `house_lists`
  ADD CONSTRAINT `house_lists_ibfk_1` FOREIGN KEY (`house_id`, `world_id`) REFERENCES `houses` (`id`, `world_id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `killers`
--
ALTER TABLE `killers`
  ADD CONSTRAINT `killers_ibfk_1` FOREIGN KEY (`death_id`) REFERENCES `player_deaths` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD CONSTRAINT `player_deaths_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD CONSTRAINT `player_depotitems_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_items`
--
ALTER TABLE `player_items`
  ADD CONSTRAINT `player_items_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_killers`
--
ALTER TABLE `player_killers`
  ADD CONSTRAINT `player_killers_ibfk_1` FOREIGN KEY (`kill_id`) REFERENCES `killers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `player_killers_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD CONSTRAINT `player_namelocks_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_skills`
--
ALTER TABLE `player_skills`
  ADD CONSTRAINT `player_skills_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_spells`
--
ALTER TABLE `player_spells`
  ADD CONSTRAINT `player_spells_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_storage`
--
ALTER TABLE `player_storage`
  ADD CONSTRAINT `player_storage_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `player_viplist`
--
ALTER TABLE `player_viplist`
  ADD CONSTRAINT `player_viplist_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `player_viplist_ibfk_2` FOREIGN KEY (`vip_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `server_reports`
--
ALTER TABLE `server_reports`
  ADD CONSTRAINT `server_reports_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `tiles`
--
ALTER TABLE `tiles`
  ADD CONSTRAINT `tiles_ibfk_1` FOREIGN KEY (`house_id`, `world_id`) REFERENCES `houses` (`id`, `world_id`) ON DELETE CASCADE;

--
-- Limitadores para a tabela `tile_items`
--
ALTER TABLE `tile_items`
  ADD CONSTRAINT `tile_items_ibfk_1` FOREIGN KEY (`tile_id`) REFERENCES `tiles` (`id`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
