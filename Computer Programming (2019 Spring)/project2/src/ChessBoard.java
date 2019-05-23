import java.awt.*;
import java.awt.event.*;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import javax.swing.*;
import javax.swing.border.*;
import java.util.List;

//======================================================Don't modify below===============================================================//
enum PieceType {king, queen, bishop, knight, rook, pawn, none}

enum PlayerColor {black, white, none}

public class ChessBoard {
    private final JPanel gui = new JPanel(new BorderLayout(3, 3));
    private JPanel chessBoard;
    private JButton[][] chessBoardSquares = new JButton[8][8];
    private Piece[][] chessBoardStatus = new Piece[8][8];
    private ImageIcon[] pieceImage_b = new ImageIcon[7];
    private ImageIcon[] pieceImage_w = new ImageIcon[7];
    private JLabel message = new JLabel("Enter Reset to Start");

    ChessBoard() {
        initPieceImages();
        initBoardStatus();
        initializeGui();
    }

    public final void initBoardStatus() {
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) chessBoardStatus[j][i] = new Piece();
        }
    }

    public final void initPieceImages() {
        pieceImage_b[0] = new ImageIcon(new ImageIcon("./img/king_b.png").getImage().getScaledInstance(64, 64, java.awt.Image.SCALE_SMOOTH));
        pieceImage_b[1] = new ImageIcon(new ImageIcon("./img/queen_b.png").getImage().getScaledInstance(64, 64, java.awt.Image.SCALE_SMOOTH));
        pieceImage_b[2] = new ImageIcon(new ImageIcon("./img/bishop_b.png").getImage().getScaledInstance(64, 64, java.awt.Image.SCALE_SMOOTH));
        pieceImage_b[3] = new ImageIcon(new ImageIcon("./img/knight_b.png").getImage().getScaledInstance(64, 64, java.awt.Image.SCALE_SMOOTH));
        pieceImage_b[4] = new ImageIcon(new ImageIcon("./img/rook_b.png").getImage().getScaledInstance(64, 64, java.awt.Image.SCALE_SMOOTH));
        pieceImage_b[5] = new ImageIcon(new ImageIcon("./img/pawn_b.png").getImage().getScaledInstance(64, 64, java.awt.Image.SCALE_SMOOTH));
        pieceImage_b[6] = new ImageIcon(new BufferedImage(64, 64, BufferedImage.TYPE_INT_ARGB));

        pieceImage_w[0] = new ImageIcon(new ImageIcon("./img/king_w.png").getImage().getScaledInstance(64, 64, java.awt.Image.SCALE_SMOOTH));
        pieceImage_w[1] = new ImageIcon(new ImageIcon("./img/queen_w.png").getImage().getScaledInstance(64, 64, java.awt.Image.SCALE_SMOOTH));
        pieceImage_w[2] = new ImageIcon(new ImageIcon("./img/bishop_w.png").getImage().getScaledInstance(64, 64, java.awt.Image.SCALE_SMOOTH));
        pieceImage_w[3] = new ImageIcon(new ImageIcon("./img/knight_w.png").getImage().getScaledInstance(64, 64, java.awt.Image.SCALE_SMOOTH));
        pieceImage_w[4] = new ImageIcon(new ImageIcon("./img/rook_w.png").getImage().getScaledInstance(64, 64, java.awt.Image.SCALE_SMOOTH));
        pieceImage_w[5] = new ImageIcon(new ImageIcon("./img/pawn_w.png").getImage().getScaledInstance(64, 64, java.awt.Image.SCALE_SMOOTH));
        pieceImage_w[6] = new ImageIcon(new BufferedImage(64, 64, BufferedImage.TYPE_INT_ARGB));
    }

    public ImageIcon getImageIcon(Piece piece) {
        if (piece.color.equals(PlayerColor.black)) {
            if (piece.type.equals(PieceType.king)) return pieceImage_b[0];
            else if (piece.type.equals(PieceType.queen)) return pieceImage_b[1];
            else if (piece.type.equals(PieceType.bishop)) return pieceImage_b[2];
            else if (piece.type.equals(PieceType.knight)) return pieceImage_b[3];
            else if (piece.type.equals(PieceType.rook)) return pieceImage_b[4];
            else if (piece.type.equals(PieceType.pawn)) return pieceImage_b[5];
            else return pieceImage_b[6];
        } else if (piece.color.equals(PlayerColor.white)) {
            if (piece.type.equals(PieceType.king)) return pieceImage_w[0];
            else if (piece.type.equals(PieceType.queen)) return pieceImage_w[1];
            else if (piece.type.equals(PieceType.bishop)) return pieceImage_w[2];
            else if (piece.type.equals(PieceType.knight)) return pieceImage_w[3];
            else if (piece.type.equals(PieceType.rook)) return pieceImage_w[4];
            else if (piece.type.equals(PieceType.pawn)) return pieceImage_w[5];
            else return pieceImage_w[6];
        } else return pieceImage_w[6];
    }

    public final void initializeGui() {
        gui.setBorder(new EmptyBorder(5, 5, 5, 5));
        JToolBar tools = new JToolBar();
        tools.setFloatable(false);
        gui.add(tools, BorderLayout.PAGE_START);
        JButton startButton = new JButton("Reset");
        startButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                initiateBoard();
            }
        });

        tools.add(startButton);
        tools.addSeparator();
        tools.add(message);

        chessBoard = new JPanel(new GridLayout(0, 8));
        chessBoard.setBorder(new LineBorder(Color.BLACK));
        gui.add(chessBoard);
        ImageIcon defaultIcon = new ImageIcon(new BufferedImage(64, 64, BufferedImage.TYPE_INT_ARGB));
        Insets buttonMargin = new Insets(0, 0, 0, 0);
        for (int i = 0; i < chessBoardSquares.length; i++) {
            for (int j = 0; j < chessBoardSquares[i].length; j++) {
                JButton b = new JButton();
                b.addActionListener(new ButtonListener(i, j));
                b.setMargin(buttonMargin);
                b.setIcon(defaultIcon);
                if ((j % 2 == 1 && i % 2 == 1) || (j % 2 == 0 && i % 2 == 0)) b.setBackground(Color.WHITE);
                else b.setBackground(Color.gray);
                b.setOpaque(true);
                b.setBorderPainted(false);
                chessBoardSquares[j][i] = b;
            }
        }

        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) chessBoard.add(chessBoardSquares[j][i]);
        }
    }

    public final JComponent getGui() {
        return gui;
    }

    public static void main(String[] args) {
        Runnable r = new Runnable() {
            @Override
            public void run() {
                ChessBoard cb = new ChessBoard();
                JFrame f = new JFrame("Chess");
                f.add(cb.getGui());
                f.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
                f.setLocationByPlatform(true);
                f.setResizable(false);
                f.pack();
                f.setMinimumSize(f.getSize());
                f.setVisible(true);
            }
        };
        SwingUtilities.invokeLater(r);
    }

    //================================Utilize these functions========================================//

    class Piece {
        PlayerColor color;
        PieceType type;

        Piece() {
            color = PlayerColor.none;
            type = PieceType.none;
        }

        Piece(PlayerColor color, PieceType type) {
            this.color = color;
            this.type = type;
        }
    }

    public void setIcon(int x, int y, Piece piece) {
        chessBoardSquares[y][x].setIcon(getImageIcon(piece));
        chessBoardStatus[y][x] = piece;
    }

    public Piece getIcon(int x, int y) {
        return chessBoardStatus[y][x];
    }

    public void markPosition(int x, int y) {
        chessBoardSquares[y][x].setBackground(Color.pink);
    }

    public void unmarkPosition(int x, int y) {
        if ((y % 2 == 1 && x % 2 == 1) || (y % 2 == 0 && x % 2 == 0))
            chessBoardSquares[y][x].setBackground(Color.WHITE);
        else chessBoardSquares[y][x].setBackground(Color.gray);
    }

    public void setStatus(String inpt) {
        message.setText(inpt);
    }

    public void initiateBoard() {
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) setIcon(i, j, new Piece());
        }
        setIcon(0, 0, new Piece(PlayerColor.black, PieceType.rook));
        setIcon(0, 1, new Piece(PlayerColor.black, PieceType.knight));
        setIcon(0, 2, new Piece(PlayerColor.black, PieceType.bishop));
        setIcon(0, 3, new Piece(PlayerColor.black, PieceType.queen));
        setIcon(0, 4, new Piece(PlayerColor.black, PieceType.king));
        setIcon(0, 5, new Piece(PlayerColor.black, PieceType.bishop));
        setIcon(0, 6, new Piece(PlayerColor.black, PieceType.knight));
        setIcon(0, 7, new Piece(PlayerColor.black, PieceType.rook));
        for (int i = 0; i < 8; i++) {
            setIcon(1, i, new Piece(PlayerColor.black, PieceType.pawn));
            setIcon(6, i, new Piece(PlayerColor.white, PieceType.pawn));
        }
        setIcon(7, 0, new Piece(PlayerColor.white, PieceType.rook));
        setIcon(7, 1, new Piece(PlayerColor.white, PieceType.knight));
        setIcon(7, 2, new Piece(PlayerColor.white, PieceType.bishop));
        setIcon(7, 3, new Piece(PlayerColor.white, PieceType.queen));
        setIcon(7, 4, new Piece(PlayerColor.white, PieceType.king));
        setIcon(7, 5, new Piece(PlayerColor.white, PieceType.bishop));
        setIcon(7, 6, new Piece(PlayerColor.white, PieceType.knight));
        setIcon(7, 7, new Piece(PlayerColor.white, PieceType.rook));
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) unmarkPosition(i, j);
        }
        onInitiateBoard();
    }
//======================================================Don't modify above==============================================================//	


    //======================================================Implement below=================================================================//
    public void unmarkAll() {
        for (int i = 0; i < 8; i++)
            for (int j = 0; j < 8; j++)
                unmarkPosition(i, j);
    }

    public void markStraight(int x, int y) {
        for (int i = x - 1; i >= 0; i--)
            if (getIcon(i, y).color == PlayerColor.none) markPosition(i, y);
            else if (getIcon(i, y).color == playerColor) break;
            else if (getIcon(i, y).color != playerColor) {
                markPosition(i, y);
                break;
            }

        for (int i = x + 1; i < 8; i++)
            if (getIcon(i, y).color == PlayerColor.none) markPosition(i, y);
            else if (getIcon(i, y).color == playerColor) break;
            else if (getIcon(i, y).color != playerColor) {
                markPosition(i, y);
                break;
            }

        for (int j = y - 1; j >= 0; j--)
            if (getIcon(x, j).color == PlayerColor.none) markPosition(x, j);
            else if (getIcon(x, j).color == playerColor) break;
            else if (getIcon(x, j).color != playerColor) {
                markPosition(x, j);
                break;
            }

        for (int j = y + 1; j < 8; j++)
            if (getIcon(x, j).color == PlayerColor.none) markPosition(x, j);
            else if (getIcon(x, j).color == playerColor) break;
            else if (getIcon(x, j).color != playerColor) {
                markPosition(x, j);
                break;
            }
    }

    public void markDiagonal(int x, int y) {
        int i = 1;
        while (x - i >= 0 && y - i >= 0) {
            if (getIcon(x - i, y - i).color == PlayerColor.none) markPosition(x - i, y - i);
            else if (getIcon(x - i, y - i).color == playerColor) break;
            else if (getIcon(x - i, y - i).color != playerColor) {
                markPosition(x - i, y - i);
                break;
            }
            i++;
        }

        i = 1;
        while (x - i >= 0 && y + i < 8) {
            if (getIcon(x - i, y + i).color == PlayerColor.none) markPosition(x - i, y + i);
            else if (getIcon(x - i, y + i).color == playerColor) break;
            else if (getIcon(x - i, y + i).color != playerColor) {
                markPosition(x - i, y + i);
                break;
            }
            i++;
        }

        i = 1;
        while (x + i < 8 && y - i >= 0) {
            if (getIcon(x + i, y - i).color == PlayerColor.none) markPosition(x + i, y - i);
            else if (getIcon(x + i, y - i).color == playerColor) break;
            else if (getIcon(x + i, y - i).color != playerColor) {
                markPosition(x + i, y - i);
                break;
            }
            i++;
        }

        i = 1;
        while (x + i < 8 && y + i < 8) {
            if (getIcon(x + i, y + i).color == PlayerColor.none) markPosition(x + i, y + i);
            else if (getIcon(x + i, y + i).color == playerColor) break;
            else if (getIcon(x + i, y + i).color != playerColor) {
                markPosition(x + i, y + i);
                break;
            }
            i++;
        }
    }

    public void mark(int x, int y, PieceType type) {
        if (type == PieceType.king) {
            int[] _x = {-1, -1, 0, 1, 1, 1, 0, -1};
            int[] _y = {0, 1, 1, 1, 0, -1, -1, -1};

            for (int i = 0; i < 8; i++) {
                int m_x = x + _x[i];
                int m_y = y + _y[i];

                if (m_x >= 0 && m_x < 8 && m_y >= 0 && m_y < 8 && playerColor != getIcon(m_x, m_y).color)
                    markPosition(m_x, m_y);
            }
        } else if (type == PieceType.queen) {
            markStraight(x, y);
            markDiagonal(x, y);
        } else if (type == PieceType.bishop) {
            markDiagonal(x, y);
        } else if (type == PieceType.knight) {
            int[] _x = {-2, -1, 1, 2, 2, 1, -1, -2};
            int[] _y = {1, 2, 2, 1, -1, -2, -2, -1};

            for (int i = 0; i < 8; i++) {
                int m_x = x + _x[i];
                int m_y = y + _y[i];

                if (m_x >= 0 && m_x < 8 && m_y >= 0 && m_y < 8 && playerColor != getIcon(m_x, m_y).color)
                    markPosition(m_x, m_y);
            }
        } else if (type == PieceType.rook) {
            markStraight(x, y);
        } else if (type == PieceType.pawn) {
            if (playerColor == PlayerColor.black && x + 1 < 8) {
                if (getIcon(x + 1, y).color == PlayerColor.none)
                    markPosition(x + 1, y);
                if (x == 1 && getIcon(x + 1, y).color == PlayerColor.none && playerColor != getIcon(x + 2, y).color)
                    markPosition(x + 2, y);
                if (y - 1 >= 0 && getIcon(x + 1, y - 1).color == PlayerColor.white)
                    markPosition(x + 1, y - 1);
                if (y + 1 < 8 && getIcon(x + 1, y + 1).color == PlayerColor.white)
                    markPosition(x + 1, y + 1);
            } else if (playerColor == PlayerColor.white && x - 1 >= 0) {
                if (getIcon(x - 1, y).color == PlayerColor.none)
                    markPosition(x - 1, y);
                if (x == 6 && getIcon(x - 1, y).color == PlayerColor.none && playerColor != getIcon(x - 2, y).color)
                    markPosition(x - 2, y);
                if (y - 1 >= 0 && getIcon(x - 1, y - 1).color == PlayerColor.black)
                    markPosition(x - 1, y - 1);
                if (y + 1 < 8 && getIcon(x - 1, y + 1).color == PlayerColor.black)
                    markPosition(x - 1, y + 1);
            }
        }
    }

    public boolean isCheck(int x, int y, PlayerColor color) {
        boolean _isCheck = false;

        // king
        int[] _x = {-1, -1, 0, 1, 1, 1, 0, -1};
        int[] _y = {0, 1, 1, 1, 0, -1, -1, -1};
        for (int i = 0; i < 8; i++) {
            int m_x = x + _x[i];
            int m_y = y + _y[i];

            if (m_x >= 0 && m_x < 8 && m_y >= 0 && m_y < 8 && getIcon(m_x, m_y).color == color && getIcon(m_x, m_y).type == PieceType.king) {
                checkList.add(new CheckList(PieceType.king, m_x, m_y));
                _isCheck = true;
                break;
            }
        }

        // knight
        _x = new int[]{-2, -1, 1, 2, 2, 1, -1, -2};
        _y = new int[]{1, 2, 2, 1, -1, -2, -2, -1};
        for (int i = 0; i < 8; i++) {
            int m_x = x + _x[i];
            int m_y = y + _y[i];

            if (m_x >= 0 && m_x < 8 && m_y >= 0 && m_y < 8 && getIcon(m_x, m_y).color == color && getIcon(m_x, m_y).type == PieceType.knight) {
                checkList.add(new CheckList(PieceType.knight, m_x, m_y));
                _isCheck = true;
            }
        }

        // pawn
        if (color == PlayerColor.black) {
            if (x - 1 >= 0 && y - 1 >= 0 && getIcon(x - 1, y - 1).color == PlayerColor.black && getIcon(x - 1, y - 1).type == PieceType.pawn) {
                checkList.add(new CheckList(PieceType.pawn, x - 1, y - 1));
                _isCheck = true;
            }
            if (x - 1 >= 0 && y + 1 < 8 && getIcon(x - 1, y + 1).color == PlayerColor.black && getIcon(x - 1, y + 1).type == PieceType.pawn) {
                checkList.add(new CheckList(PieceType.pawn, x - 1, y + 1));
                _isCheck = true;
            }
        }
        if (color == PlayerColor.white) {
            if (x + 1 < 8 && y - 1 >= 0 && getIcon(x + 1, y - 1).color == PlayerColor.white && getIcon(x + 1, y - 1).type == PieceType.pawn) {
                checkList.add(new CheckList(PieceType.pawn, x + 1, y - 1));
                _isCheck = true;
            }
            if (x + 1 < 8 && y + 1 < 8 && getIcon(x + 1, y + 1).color == PlayerColor.white && getIcon(x + 1, y + 1).type == PieceType.pawn) {
                checkList.add(new CheckList(PieceType.pawn, x + 1, y + 1));
                _isCheck = true;
            }
        }

        // queen, rook (straight)
        for (int i = x - 1; i >= 0; i--)
            if (getIcon(i, y).color != PlayerColor.none)
                if (getIcon(i, y).color == color && (getIcon(i, y).type == PieceType.queen || getIcon(i, y).type == PieceType.rook)) {
                    checkList.add(new CheckList(getIcon(i, y).type, i, y));
                    _isCheck = true;
                } else break;
        for (int i = x + 1; i < 8; i++)
            if (getIcon(i, y).color != PlayerColor.none)
                if (getIcon(i, y).color == color && (getIcon(i, y).type == PieceType.queen || getIcon(i, y).type == PieceType.rook)) {
                    checkList.add(new CheckList(getIcon(i, y).type, i, y));
                    _isCheck = true;
                } else break;
        for (int j = y - 1; j >= 0; j--)
            if (getIcon(x, j).color != PlayerColor.none)
                if (getIcon(x, j).color == color && (getIcon(x, j).type == PieceType.queen || getIcon(x, j).type == PieceType.rook)) {
                    checkList.add(new CheckList(getIcon(x, j).type, x, j));
                    _isCheck = true;
                } else break;
        for (int j = y + 1; j < 8; j++)
            if (getIcon(x, j).color != PlayerColor.none)
                if (getIcon(x, j).color == color && (getIcon(x, j).type == PieceType.queen || getIcon(x, j).type == PieceType.rook)) {
                    checkList.add(new CheckList(getIcon(x, j).type, x, j));
                    _isCheck = true;
                } else break;

        // queen, bishop (diagonal)
        int i = 1;
        while (x - i >= 0 && y - i >= 0) {
            if (getIcon(x - i, y - i).color != PlayerColor.none)
                if (getIcon(x - i, y - i).color == color && (getIcon(x - i, y - i).type == PieceType.queen || getIcon(x - i, y - i).type == PieceType.bishop)) {
                    checkList.add(new CheckList(getIcon(x - i, y - i).type, x - i, y - i));
                    _isCheck = true;
                } else break;
            i++;
        }
        i = 1;
        while (x - i >= 0 && y + i < 8) {
            if (getIcon(x - i, y + i).color != PlayerColor.none)
                if (getIcon(x - i, y + i).color == color && (getIcon(x - i, y + i).type == PieceType.queen || getIcon(x - i, y + i).type == PieceType.bishop)) {
                    checkList.add(new CheckList(getIcon(x - i, y + i).type, x - i, y + i));
                    _isCheck = true;
                } else break;
            i++;
        }
        i = 1;
        while (x + i < 8 && y - i >= 0) {
            if (getIcon(x + i, y - i).color != PlayerColor.none)
                if (getIcon(x + i, y - i).color == color && (getIcon(x + i, y - i).type == PieceType.queen || getIcon(x + i, y - i).type == PieceType.bishop)) {
                    checkList.add(new CheckList(getIcon(x + i, y - i).type, x + i, y - i));
                    _isCheck = true;
                } else break;
            i++;
        }
        i = 1;
        while (x + i < 8 && y + i < 8) {
            if (getIcon(x + i, y + i).color != PlayerColor.none)
                if (getIcon(x + i, y + i).color == color && (getIcon(x + i, y + i).type == PieceType.queen || getIcon(x + i, y + i).type == PieceType.bishop)) {
                    checkList.add(new CheckList(getIcon(x + i, y + i).type, x + i, y + i));
                    _isCheck = true;
                } else break;
            i++;
        }

        if (_isCheck) return true;
        else return false;
    }

    public boolean isRemovable(int x, int y, PlayerColor color) {
        // knight
        int[] _x = {-2, -1, 1, 2, 2, 1, -1, -2};
        int[] _y = {1, 2, 2, 1, -1, -2, -2, -1};
        for (int i = 0; i < 8; i++) {
            int m_x = x + _x[i];
            int m_y = y + _y[i];

            if (m_x >= 0 && m_x < 8 && m_y >= 0 && m_y < 8 && getIcon(m_x, m_y).color != color && getIcon(m_x, m_y).type == PieceType.knight)
                return true;
        }

        // pawn
        if (color == PlayerColor.black) {
            if (x + 1 < 8 && y - 1 >= 0 && getIcon(x + 1, y - 1).color == PlayerColor.white && getIcon(x + 1, y - 1).type == PieceType.pawn)
                return true;
            if (x + 1 < 8 && y + 1 < 8 && getIcon(x + 1, y + 1).color == PlayerColor.white && getIcon(x + 1, y + 1).type == PieceType.pawn)
                return true;
        }
        if (color == PlayerColor.white) {
            if (x - 1 >= 0 && y - 1 >= 0 && getIcon(x - 1, y - 1).color == PlayerColor.black && getIcon(x - 1, y - 1).type == PieceType.pawn)
                return true;
            if (x - 1 >= 0 && y + 1 < 8 && getIcon(x - 1, y + 1).color == PlayerColor.black && getIcon(x - 1, y + 1).type == PieceType.pawn)
                return true;
        }

        // queen, rook (straight)
        for (int i = x - 1; i >= 0; i--)
            if (getIcon(i, y).color != PlayerColor.none)
                if (getIcon(i, y).color != color && (getIcon(i, y).type == PieceType.queen || getIcon(i, y).type == PieceType.rook))
                    return true;
                else break;
        for (int i = x + 1; i < 8; i++)
            if (getIcon(i, y).color != PlayerColor.none)
                if (getIcon(i, y).color != color && (getIcon(i, y).type == PieceType.queen || getIcon(i, y).type == PieceType.rook))
                    return true;
                else break;
        for (int j = y - 1; j >= 0; j--)
            if (getIcon(x, j).color != PlayerColor.none)
                if (getIcon(x, j).color != color && (getIcon(x, j).type == PieceType.queen || getIcon(x, j).type == PieceType.rook))
                    return true;
                else break;
        for (int j = y + 1; j < 8; j++)
            if (getIcon(x, j).color != PlayerColor.none)
                if (getIcon(x, j).color != color && (getIcon(x, j).type == PieceType.queen || getIcon(x, j).type == PieceType.rook))
                    return true;
                else break;

        // queen, bishop (diagonal)
        int i = 1;
        while (x - i >= 0 && y - i >= 0) {
            if (getIcon(x - i, y - i).color != PlayerColor.none)
                if (getIcon(x - i, y - i).color != color && (getIcon(x - i, y - i).type == PieceType.queen || getIcon(x - i, y - i).type == PieceType.bishop))
                    return true;
                else break;
            i++;
        }
        i = 1;
        while (x - i >= 0 && y + i < 8) {
            if (getIcon(x - i, y + i).color != PlayerColor.none)
                if (getIcon(x - i, y + i).color != color && (getIcon(x - i, y + i).type == PieceType.queen || getIcon(x - i, y + i).type == PieceType.bishop))
                    return true;
                else break;
            i++;
        }
        i = 1;
        while (x + i < 8 && y - i >= 0) {
            if (getIcon(x + i, y - i).color != PlayerColor.none)
                if (getIcon(x + i, y - i).color != color && (getIcon(x + i, y - i).type == PieceType.queen || getIcon(x + i, y - i).type == PieceType.bishop))
                    return true;
                else break;
            i++;
        }
        i = 1;
        while (x + i < 8 && y + i < 8) {
            if (getIcon(x + i, y + i).color != PlayerColor.none)
                if (getIcon(x + i, y + i).color != color && (getIcon(x + i, y + i).type == PieceType.queen || getIcon(x + i, y + i).type == PieceType.bishop))
                    return true;
                else break;
            i++;
        }

        return false;
    }

    public boolean isBlockStraight(int x, int y, int k_x, int k_y, PlayerColor color) {
        if (x == k_x) {
            for (int j = Math.min(y, k_y) + 1; j < Math.max(y, k_y); j++)
                if (isCheck(x, j, color)) return true;
        } else if (y == k_y) {
            for (int i = Math.min(x, k_x) + 1; i < Math.max(x, k_x); i++)
                if (isCheck(i, y, color)) return true;
        }

        return false;
    }

    public boolean isBlockDiagonal(int x, int y, int k_x, int k_y, PlayerColor color) {
        // TODO

        return false;
    }

    public boolean isBlock(int x, int y, PlayerColor color, PieceType type) {
        int k_x, k_y;

        if (color == PlayerColor.black) {
            k_x = kingX_w;
            k_y = kingY_w;
        } else {
            k_x = kingX_b;
            k_y = kingY_b;
        }

        if (type == PieceType.queen) {
            if ((x == k_x || y == k_y) && isBlockStraight(x, y, k_x, k_y, color)) return true;
            else if (Math.abs(k_x - x) == Math.abs(k_y - y) && isBlockDiagonal(x, y, k_x, k_y, color)) return true;
        } else if (type == PieceType.bishop) {
            if (isBlockDiagonal(x, y, k_x, k_y, color)) return true;
        } else if (type == PieceType.rook) {
            if (isBlockStraight(x, y, k_x, k_y, color)) return true;
        }

        return false;
    }

    public boolean isCheckmate(int x, int y, PlayerColor color) {
        checkList = new ArrayList<CheckList>();

        if (!isCheck(x, y, color)) return false;

        Piece tmp = chessBoardStatus[y][x];
        chessBoardStatus[y][x] = new Piece();

        if (checkList.size() == 1) {
            int c_x = checkList.get(0).getX();
            int c_y = checkList.get(0).getY();
            PieceType c_type = checkList.get(0).getType();

            if (isRemovable(c_x, c_y, color)) {
                chessBoardStatus[y][x] = tmp;
                return false;
            }
            if (isBlock(c_x, c_y, color, c_type)) {
                chessBoardStatus[y][x] = tmp;
                return false;
            }
        }

        int[] _x = {-1, -1, 0, 1, 1, 1, 0, -1};
        int[] _y = {0, 1, 1, 1, 0, -1, -1, -1};

        for (int i = 0; i < 8; i++) {
            int m_x = x + _x[i];
            int m_y = y + _y[i];

            if (m_x >= 0 && m_x < 8 && m_y >= 0 && m_y < 8 && (getIcon(m_x, m_y).color == PlayerColor.none || getIcon(m_x, m_y).color == color) && !isCheck(m_x, m_y, color)) {
                chessBoardStatus[y][x] = tmp;
                return false;
            }
        }

        chessBoardStatus[y][x] = tmp;
        return true;
    }

    class CheckList {
        PieceType type;
        int x;
        int y;

        CheckList(PieceType type, int x, int y) {
            this.type = type;
            this.x = x;
            this.y = y;
        }

        PieceType getType() {
            return type;
        }

        int getX() {
            return x;
        }

        int getY() {
            return y;
        }
    }

    enum MagicType {MARK, CHECK, CHECKMATE}

    private int selX, selY, kingX_b, kingY_b, kingX_w, kingY_w;
    private boolean check, checkmate, end;
    private PlayerColor playerColor;
    private List<CheckList> checkList = new ArrayList<CheckList>();

    class ButtonListener implements ActionListener {
        int x;
        int y;

        ButtonListener(int x, int y) {
            this.x = x;
            this.y = y;
        }

        public void actionPerformed(ActionEvent e) {    // Only modify here
            // (x, y) is where the click event occured

            if (end) return;

            if (chessBoardSquares[y][x].getBackground() == Color.pink) {
                unmarkAll();

                String status = "";
                if (playerColor == PlayerColor.black) status += "WHITE's TURN";
                else if (playerColor == PlayerColor.white) status += "BLACK's TURN";

                if (getIcon(selX, selY).type == PieceType.king)
                    if (playerColor == PlayerColor.black) {
                        kingX_b = x;
                        kingY_b = y;
                    } else if (playerColor == PlayerColor.white) {
                        kingX_w = x;
                        kingY_w = y;
                    }

                if (getIcon(x, y).type == PieceType.king) {
                    end = true;
                    if (playerColor == PlayerColor.black) status += " / END / BLACK WIN!";
                    else if (playerColor == PlayerColor.white) status += " / END / WHITE WIN!";
                }

                setIcon(x, y, getIcon(selX, selY));
                setIcon(selX, selY, new Piece());

                if (isCheckmate(kingX_w, kingY_w, PlayerColor.black)) {
                    end = true;
                    status += " / CHECKMATE / BLACK WIN!";
                } else if (isCheckmate(kingX_b, kingY_b, PlayerColor.white)) {
                    end = true;
                    status += " / CHECKMATE / WHITE WIN!";
                } else if (isCheck(kingX_w, kingY_w, PlayerColor.black) || isCheck(kingX_b, kingY_b, PlayerColor.white))
                    status += " / CHECK";

                if (playerColor == PlayerColor.black) playerColor = PlayerColor.white;
                else if (playerColor == PlayerColor.white) playerColor = PlayerColor.black;

                setStatus(status);
            } else if (playerColor == getIcon(x, y).color) {
                unmarkAll();

                mark(x, y, getIcon(x, y).type);

                selX = x;
                selY = y;
            }
        }
    }

    void onInitiateBoard() {
        playerColor = PlayerColor.black;

        setStatus("BLACK's TURN");

        kingX_b = 0;
        kingY_b = 4;
        kingX_w = 7;
        kingY_w = 4;
    }
}