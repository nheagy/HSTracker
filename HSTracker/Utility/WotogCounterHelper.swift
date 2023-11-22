//
//  WotogCounterHelper.swift
//  HSTracker
//
//  Created by Benjamin Michotte on 28/04/16.
//  Copyright © 2016 Benjamin Michotte. All rights reserved.
//

import Foundation

extension Game {
    static let spellCounterCards = [
        CardIds.Collectible.Neutral.YoggSaronHopesEnd,
        CardIds.Collectible.Neutral.ArcaneGiant,
        CardIds.Collectible.Priest.GraveHorror,
        CardIds.Collectible.Druid.UmbralOwlDARKMOON_FAIRE,
        CardIds.Collectible.Druid.UmbralOwlPLACEHOLDER_202204
    ]
    
    static let excavateCounterCards = [
        CardIds.Collectible.Rogue.BloodrockCoShovel,
        CardIds.Collectible.Warlock.Smokestack,
        CardIds.Collectible.Mage.Cryopreservation,
        CardIds.Collectible.Neutral.KoboldMiner,
        CardIds.Collectible.Warrior.BlastCharge,
        CardIds.Collectible.Deathknight.ReapWhatYouSow,
        CardIds.Collectible.Warrior.ReinforcedPlating,
        CardIds.Collectible.Rogue.DrillyTheKid,
        CardIds.Collectible.Warlock.MoargDrillfist,
        CardIds.Collectible.Deathknight.SkeletonCrew,
        CardIds.Collectible.Neutral.BurrowBuster,
        CardIds.Collectible.Mage.BlastmageMiner
    ]
    
	var playerCthun: Entity? {
		return self.player.playerEntities
			.first { $0.cardId == CardIds.Collectible.Neutral.Cthun }
	}
	
	var playerCthunProxy: Entity? {
		return self.player.playerEntities
			.first { $0.cardId == CardIds.NonCollectible.Neutral.Cthun }
	}
	
	var playerYogg: Entity? {
		return self.player.playerEntities
			.first { $0.cardId == CardIds.Collectible.Neutral.YoggSaronHopesEnd }
	}
	
	var playerNzoth: Entity? {
		return self.player.playerEntities
			.first { $0.cardId == CardIds.Collectible.Neutral.NzothTheCorruptor }
	}
	
	var opponentCthun: Entity? {
		return self.opponent.playerEntities
			.first { $0.cardId == CardIds.Collectible.Neutral.Cthun }
	}
	
	var opponentCthunProxy: Entity? {
		return self.opponent.playerEntities
			.first { $0.cardId == CardIds.NonCollectible.Neutral.Cthun }
	}
	
    var playerSeenCthun: Bool {
        let cthun = playerCthun
        return cthun != nil
    }

    var opponentSeenCthun: Bool {
        return opponentCthun != nil
    }
    
	var playerSeenJade: Bool {
		return self.playerEntity?.has(tag: .jade_golem) ?? false
	}
	
	var playerNextJadeGolem: Int {
		let jade = self.playerEntity?[.jade_golem] ?? 0
		return playerSeenJade ? min(jade + 1, 30) : 1
	}
	
	var opponentSeenJade: Bool {
		return self.opponentEntity?.has(tag: .jade_golem) ?? false
	}
	
	var opponentNextJadeGolem: Int {
		let jade = self.opponentEntity?[.jade_golem] ?? 0
		return opponentSeenJade ? min(jade + 1, 30) : 1
	}
	
	private func deckContains(cardId: String) -> Bool {
		return self.currentDeck?.cards.any({ $0.id == cardId }) ?? false
	}
	
	var cthunInDeck: Bool {
		return deckContains(cardId: CardIds.Collectible.Neutral.Cthun)
	}
	
	var nzothInDeck: Bool {
		return deckContains(cardId: CardIds.Collectible.Neutral.NzothTheCorruptor)
	}
	
	var showPlayerCthunCounter: Bool {
		return Settings.showPlayerCthun && playerSeenCthun
	}
	
    var showPlayerSpellsCounter: Bool {
        guard Settings.showPlayerSpell else {
            return false
        }
        return true
    }
		
	
	var showPlayerDeathrattleCounter: Bool {
		return Settings.showPlayerDeathrattle
			&& (playerYogg != nil || nzothInDeck == true)
	}
	
	var showPlayerJadeCounter: Bool {
		return Settings.showPlayerJadeCounter && playerSeenJade
	}
	
	var showOpponentJadeCounter: Bool {
		return Settings.showOpponentJadeCounter && opponentSeenJade
	}
	
	var showOpponentCthunCounter: Bool {
		return Settings.showOpponentCthun && opponentSeenCthun
	}
    
    var playerLibramCounter: Int {
        return self.player.libramReductionCount
    }

    var opponentLibramCounter: Int {
        return self.opponent.libramReductionCount
    }
    
    var showPlayerAbyssalCounter: Bool {
        return !isInMenu && Settings.showPlayerAbyssalCounter && player.abyssalCurseCount > 0
    }
    
    var showOpponentAbyssalCounter: Bool {
        return !isInMenu && Settings.showOpponentAbyssalCounter && opponent.abyssalCurseCount > 0
    }
    
    var showOpponentExcavateCounter: Bool {
        return !isInMenu && Settings.showOpponentExcavateCounter && (opponentEntity?[.gametag_2822] ?? 0) > 0
    }
    
    var showPlayerExcavateTier: Bool {
        return !isInMenu && Settings.showPlayerExcavateTier && inDeckAndHand(cardIds: Game.excavateCounterCards)
    }
            
    private func inDeckAndHand(cardIds: [String]) -> Bool {
        return cardIds.any { x in inDeckOrKnown(cardId: x) }
    }

    private func inDeckOrKnown(cardId: String) -> Bool {
        let contains = deckContains(cardId: cardId)
        return  contains || player.playerEntities.first { x in x.cardId == cardId && x.info.originalZone != nil } != nil
    }
}
