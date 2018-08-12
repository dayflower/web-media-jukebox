<template lang="pug">
  div#app
    div#container
      div#header
        el-button(@click="btnRandomPlayClicked", type="primary", round)
          font-awesome-icon(icon="random")
          |
          | Random Play
        el-button(@click="btnPrevClicked", type="primary", round)
          font-awesome-icon(icon="fast-backward")
          |
          | Previous
        el-button(@click="btnPlayClicked", type="primary", round)
          font-awesome-icon(icon="play")
          |
          | Play
        el-button(@click="btnNextClicked", type="primary", round)
          font-awesome-icon(icon="fast-forward")
          |
          | Next
        el-button(@click="btnStopClicked", type="primary", round)
          font-awesome-icon(icon="stop")
          |
          | Stop
        span(style={display: "inline-block", width: "12px"})
        el-checkbox(v-model="randomMode", label="Random mode")
      div#main
        div#aside
          el-table(ref="songsTable", :data="songs", highlight-current-row, @current-change="songSelected")
            el-table-column(prop="album")
            el-table-column(prop="title")
        div#media
          video#player(controls, :src="videoSrc", @ended="ended", @loadeddata="loadedData")
</template>

<script>
export default {
  name: 'app',
  components: {
  },
  data: function () {
    return {
      randomMode: false,
      songs: undefined,
      selectedSong: undefined,
      videoSrc: undefined
    }
  },
  created: function () {
    window.addEventListener('keydown', (ev) => {
      ev.stopPropagation()

      this.keyDown(ev)
    }, true)

    this.loadList()
  },
  methods: {
    songSelected: function (song) {
      this.selectedSong = song.id

      this.videoSrc = song.url
    },
    randomIndex: function () {
      return Math.floor(Math.random() * this.songs.length)
    },
    selectRandomSong: function () {
      const cur = this.selectedSong

      let i
      for (var x = 0; x < 10; x++) {
        i = this.randomIndex()
        if (i !== cur) {
          break
        }
      }

      this.$refs.songsTable.setCurrentRow(this.songs[i])
    },
    selectNextSong: function () {
      const cur = this.selectedSong || -1
      const i = ( cur + 1 ) % this.songs.length

      this.$refs.songsTable.setCurrentRow(this.songs[i])
    },
    selectPrevSong: function () {
      const cur = this.selectedSong || 0
      const i = ( cur + this.songs.length - 1 ) % this.songs.length

      this.$refs.songsTable.setCurrentRow(this.songs[i])
    },
    loadList: function () {
      const self = this

      fetch('items.json')
        .then(function (res) {
          return res.json()
        })
        .then(function (json) {
          self.setSongs(json)
        })
    },
    setSongs: function (songs) {
      this.songs = songs.map((song, idx) => {
        song.id = idx
        return song
      })
    },
    ended: function (ev) {
      if (this.randomMode) {
        this.selectRandomSong()
      } else {
        this.selectNextSong()
      }
    },
    loadedData: function (ev) {
      document.getElementById('player').play()
    },
    keyDown: function (ev) {
      console.log(ev)
      switch (ev.code) {
      case "KeyR":
        this.btnRandomPlayClicked()
        return
      case "ArrowUp":
      case "ArrowLeft":
        this.btnPrevClicked()
        return
      case "ArrowDown":
      case "ArrowRight":
        this.btnNextClicked()
        return
      case "KeyP":
        this.btnPlayClicked()
        return
      case "Escape":
      case "KeyS":
        this.btnStopClicked()
        return
      case "Space":
      case "Enter":
        if (document.getElementById('player').paused) {
          this.btnPlayClicked()
        } else {
          this.btnStopClicked()
        }
        ev.preventDefault()
        return
      }
    },
    btnRandomPlayClicked: function (ev) {
      this.randomMode = true
      this.selectRandomSong()
    },
    btnPlayClicked: function (ev) {
      if (this.selectedSong === undefined) {
        if (this.randomMode) {
          this.selectRandomSong()
        } else {
          this.selectNextSong()
        }
        return
      }

      document.getElementById('player').play()
    },
    btnStopClicked: function (ev) {
      document.getElementById('player').pause()
    },
    btnNextClicked: function (ev) {
      this.selectNextSong()
    },
    btnPrevClicked: function (ev) {
      this.selectPrevSong()
    }
  }
}
</script>

<style>
html,
body {
  height: 100%;
}

#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  height: 100%;
}

#app:focus {
  border: none;
}

#container {
  display: flex;
  flex-direction: column;
  height: 100%;
}

#header {
  flex: 0 0 60px;
  position: sticky;
}

#main {
  flex: 1 1 auto;
  display: flex;
  flex-direction: row;
}

#aside {
  flex: 0 0 30%;
  overflow-y: scroll;
}

#media {
  flex: 1 1 auto;
  position: sticky;
}

#player {
  width: 100%;
}
</style>
